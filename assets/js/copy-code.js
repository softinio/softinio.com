(function () {
  'use strict';

  function addCopyButtons() {
    var blocks = document.querySelectorAll('.article-body pre');

    blocks.forEach(function (block) {
      // skip if already has a button
      if (block.querySelector('.copy-code-btn')) return;

      var btn = document.createElement('button');
      btn.className = 'copy-code-btn';
      btn.setAttribute('aria-label', 'Copy code');
      btn.title = 'Copy code';
      btn.innerHTML =
        '<svg viewBox="0 0 24 24" width="14" height="14" fill="none" stroke="currentColor" stroke-width="1.5" stroke-linecap="round" stroke-linejoin="round">' +
        '<rect x="9" y="9" width="13" height="13" rx="2"/>' +
        '<path d="M5 15H4a2 2 0 0 1-2-2V4a2 2 0 0 1 2-2h9a2 2 0 0 1 2 2v1"/>' +
        '</svg>';

      btn.addEventListener('click', function () {
        var code = block.querySelector('code');
        var text = code ? code.textContent : block.textContent;

        navigator.clipboard.writeText(text).then(function () {
          btn.innerHTML =
            '<svg viewBox="0 0 24 24" width="14" height="14" fill="none" stroke="currentColor" stroke-width="1.5" stroke-linecap="round" stroke-linejoin="round">' +
            '<polyline points="20 6 9 17 4 12"/>' +
            '</svg>';
          btn.classList.add('copied');

          setTimeout(function () {
            btn.innerHTML =
              '<svg viewBox="0 0 24 24" width="14" height="14" fill="none" stroke="currentColor" stroke-width="1.5" stroke-linecap="round" stroke-linejoin="round">' +
              '<rect x="9" y="9" width="13" height="13" rx="2"/>' +
              '<path d="M5 15H4a2 2 0 0 1-2-2V4a2 2 0 0 1 2-2h9a2 2 0 0 1 2 2v1"/>' +
              '</svg>';
            btn.classList.remove('copied');
          }, 2000);
        });
      });

      // Build the wrapper before touching the live DOM.
      // replaceWith() atomically swaps block → wrapper (one write).
      // block is now detached, so appendChild() needs no layout read.
      // This avoids the forced reflow caused by the old two-step
      // insertBefore(wrapper) → appendChild(block) pattern.
      var wrapper = document.createElement('div');
      wrapper.className = 'code-block-wrapper';
      block.replaceWith(wrapper);
      wrapper.appendChild(block);
      wrapper.appendChild(btn);
    });
  }

  if (document.readyState === 'loading') {
    document.addEventListener('DOMContentLoaded', addCopyButtons);
  } else {
    addCopyButtons();
  }
})();
