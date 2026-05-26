(function () {
  'use strict';

  var btn = document.querySelector('.theme-toggle');
  if (!btn) return;

  function getTheme() {
    var stored = localStorage.getItem('theme');
    if (stored) return stored;
    return window.matchMedia('(prefers-color-scheme: dark)').matches ? 'dark' : 'light';
  }

  function setTheme(theme) {
    document.documentElement.setAttribute('data-theme', theme);
    localStorage.setItem('theme', theme);
  }

  btn.addEventListener('click', function () {
    var current = document.documentElement.getAttribute('data-theme') || getTheme();
    setTheme(current === 'dark' ? 'light' : 'dark');
  });

  // Listen for OS-level changes when no manual preference
  window.matchMedia('(prefers-color-scheme: dark)').addEventListener('change', function (e) {
    if (!localStorage.getItem('theme')) {
      setTheme(e.matches ? 'dark' : 'light');
    }
  });
})();
