import { createClient, SupabaseClient, RealtimeChannel } from '@supabase/supabase-js';

const STORAGE_PREFIX = 'homebite_data_';

export const localDb = {
  get: <T>(key: string, defaultValue: T): T => {
    try {
      const item = localStorage.getItem(STORAGE_PREFIX + key);
      return item ? JSON.parse(item) : defaultValue;
    } catch (e) {
      console.warn('Error reading from localStorage', e);
      return defaultValue;
    }
  },
  set: <T>(key: string, value: T): void => {
    try {
      localStorage.setItem(STORAGE_PREFIX + key, JSON.stringify(value));
    } catch (e) {
      console.warn('Error writing to localStorage', e);
    }
  },
  remove: (key: string): void => {
    try {
      localStorage.removeItem(STORAGE_PREFIX + key);
    } catch (e) {
      console.warn('Error removing from localStorage', e);
    }
  }
};

// Retrieve configured or saved credentials
export const getStoredSupabaseConfig = () => {
  const envUrl = import.meta.env.VITE_SUPABASE_URL;
  const envKey = import.meta.env.VITE_SUPABASE_ANON_KEY;
  
  const savedUrl = localStorage.getItem('homebite_supabase_url');
  const savedKey = localStorage.getItem('homebite_supabase_key');

  const url = savedUrl || envUrl || 'https://ihzljqgkhxsmrvfudnba.supabase.co';
  const key = savedKey || envKey || 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImloemxqcWdraHhzbXJ2ZnVkbmJhIiwicm9sZSI6ImFub24iLCJpYXQiOjE3Mzg1Mzg5NTcsImV4cCI6MjA1NDExNDk1N30.demo_public_key';

  const isConfigured = Boolean(
    (savedUrl && savedKey) ||
    (envUrl && envKey && envUrl !== 'https://xyzcompany.supabase.co')
  );

  return { url, key, isConfigured };
};

const initialConfig = getStoredSupabaseConfig();

export let isSupabaseConfigured = initialConfig.isConfigured;

export const createSupabaseInstance = (url: string, key: string): SupabaseClient => {
  return createClient(url, key, {
    realtime: {
      params: {
        eventsPerSecond: 20
      }
    }
  });
};

export let supabase: SupabaseClient = createSupabaseInstance(initialConfig.url, initialConfig.key);

// Global Realtime Broadcast & Postgres Listener Channel
export let globalRealtimeChannel: RealtimeChannel = supabase.channel('homebite-global-sync', {
  config: {
    broadcast: { ack: true, self: true }
  }
});

// Update credentials dynamically without page reload
export const setSupabaseCredentials = (url: string, key: string) => {
  localStorage.setItem('homebite_supabase_url', url.trim());
  localStorage.setItem('homebite_supabase_key', key.trim());
  isSupabaseConfigured = true;
  supabase = createSupabaseInstance(url.trim(), key.trim());
  globalRealtimeChannel = supabase.channel('homebite-global-sync', {
    config: { broadcast: { ack: true, self: true } }
  });
};

export const broadcastRealtimeEvent = async (event: string, payload: any) => {
  try {
    if (globalRealtimeChannel) {
      await globalRealtimeChannel.send({
        type: 'broadcast',
        event,
        payload: {
          ...payload,
          _timestamp: new Date().toISOString()
        }
      });
    }
  } catch (err) {
    console.warn('Realtime broadcast error:', err);
  }
};
