import defaultTheme from "tailwindcss/defaultTheme";

/** @type {import('tailwindcss').Config} */
export default {
  content: ["./src/**/*.{astro,html,js,jsx,md,mdx,svelte,ts,tsx,vue}"],
  theme: {
    extend: {
      fontFamily: {
        kiwimaru: ["Kiwi Maru", ...defaultTheme.fontFamily.sans],
      },
    },
  },
  plugins: [],
};
