/** @type {import('tailwindcss').Config} */
export default {
  content: [
    "./index.html",
    "./src/**/*.{js,ts,jsx,tsx}",
  ],
  theme: {
    extend: {
      colors: {
        hb: {
          green: {
            DEFAULT: '#238B57',
            50: '#f0f9f4',
            100: '#dbf0e4',
            200: '#b9e2cb',
            300: '#8bceab',
            400: '#56b386',
            500: '#238B57',
            600: '#1b7447',
            700: '#165c3a',
            800: '#144a30',
            900: '#113d29',
          },
          cream: {
            DEFAULT: '#FFF9EF',
            50: '#ffffff',
            100: '#FFF9EF',
            200: '#faedd1',
            300: '#f5ddad',
            400: '#ecc482',
            500: '#e1a657',
          },
          orange: {
            DEFAULT: '#F59E42',
            50: '#fef8f0',
            100: '#fdf0dd',
            200: '#fadebb',
            300: '#f6c38f',
            400: '#f59e42',
            500: '#eb8122',
            600: '#cd6517',
            700: '#ab4c16',
          }
        }
      },
      fontFamily: {
        sans: ['Plus Jakarta Sans', 'Inter', 'system-ui', 'sans-serif'],
        display: ['Outfit', 'Plus Jakarta Sans', 'sans-serif'],
      },
      boxShadow: {
        'soft': '0 4px 20px -2px rgba(35, 139, 87, 0.08), 0 2px 6px -1px rgba(0, 0, 0, 0.04)',
        'card': '0 8px 30px rgba(0, 0, 0, 0.06)',
        'float': '0 12px 40px -4px rgba(35, 139, 87, 0.16)',
      }
    },
  },
  plugins: [],
}

