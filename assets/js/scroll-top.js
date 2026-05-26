(function () {
  'use strict';

  var btn = document.querySelector('.scroll-top');
  if (!btn) return;

  var ticking = false;

  function update() {
    if (window.scrollY > 300) {
      btn.classList.add('visible');
    } else {
      btn.classList.remove('visible');
    }
    ticking = false;
  }

  // Batch DOM writes via rAF to avoid forced reflows
  window.addEventListener('scroll', function () {
    if (!ticking) {
      requestAnimationFrame(update);
      ticking = true;
    }
  }, { passive: true });

  // Initial visibility check — defer to avoid layout thrash on load
  requestAnimationFrame(update);

  btn.addEventListener('click', function () {
    window.scrollTo({ top: 0, behavior: 'smooth' });
  });
})();
