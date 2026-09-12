// GlobalCanasta storefront behaviours (header drawer, menus, sticky shadow,
// quantity steppers, listing filter sheet, PDP sticky bar). Vanilla JS; runs
// after the jQuery/Bootstrap bundle so it can coexist with legacy handlers.
(function () {
  'use strict';

  function qs(sel, ctx) { return (ctx || document).querySelector(sel); }
  function qsa(sel, ctx) { return Array.prototype.slice.call((ctx || document).querySelectorAll(sel)); }

  // ----- Mobile / tablet drawer -----
  function initDrawer() {
    var drawer = qs('#gc-drawer');
    var openBtn = qs('#gc-menu-open');
    if (!drawer || !openBtn) return;

    function open() {
      drawer.classList.add('is-open');
      drawer.setAttribute('aria-hidden', 'false');
      openBtn.setAttribute('aria-expanded', 'true');
      document.body.classList.add('gc-drawer-open');
      var first = qs('[data-gc-drawer-close]', drawer);
      if (first) first.focus();
    }
    function close() {
      drawer.classList.remove('is-open');
      drawer.setAttribute('aria-hidden', 'true');
      openBtn.setAttribute('aria-expanded', 'false');
      document.body.classList.remove('gc-drawer-open');
      openBtn.focus();
    }
    openBtn.addEventListener('click', open);
    qsa('[data-gc-drawer-close]', drawer).forEach(function (el) { el.addEventListener('click', close); });
    document.addEventListener('keydown', function (e) {
      if (e.key === 'Escape' && drawer.classList.contains('is-open')) close();
    });
  }

  // ----- Account dropdown -----
  function initAccountMenu() {
    var menu = qs('#gc-account-menu');
    if (!menu) return;
    var toggle = qs('.gc-menu__toggle', menu);
    function setOpen(state) {
      menu.classList.toggle('is-open', state);
      toggle.setAttribute('aria-expanded', state ? 'true' : 'false');
    }
    toggle.addEventListener('click', function (e) {
      e.preventDefault();
      setOpen(!menu.classList.contains('is-open'));
    });
    document.addEventListener('click', function (e) {
      if (!menu.contains(e.target)) setOpen(false);
    });
    document.addEventListener('keydown', function (e) { if (e.key === 'Escape') setOpen(false); });
  }

  // ----- Sticky header shadow -----
  function initStickyShadow() {
    var row = qs('#gc-header-row1');
    if (!row) return;
    var sentinel = document.createElement('div');
    sentinel.style.cssText = 'position:absolute;height:1px;width:1px;top:0;left:0;';
    row.parentNode.style.position = 'relative';
    row.parentNode.insertBefore(sentinel, row);
    if ('IntersectionObserver' in window) {
      new IntersectionObserver(function (entries) {
        row.classList.toggle('is-stuck', !entries[0].isIntersecting);
      }, { threshold: [1] }).observe(sentinel);
    } else {
      window.addEventListener('scroll', function () {
        row.classList.toggle('is-stuck', window.pageYOffset > 40);
      }, { passive: true });
    }
  }

  // ----- Quantity steppers (cards, PDP, cart) -----
  // Markup: .gc-stepper > [data-gc-step="-1"] input [data-gc-step="1"], with
  // data-gc-max on the stepper for the stock ceiling.
  function initSteppers() {
    document.addEventListener('click', function (e) {
      var btn = e.target.closest('[data-gc-step]');
      if (!btn) return;
      e.preventDefault();
      var stepper = btn.closest('.gc-stepper');
      var input = stepper && stepper.querySelector('input');
      if (!input) return;
      var step = parseInt(btn.getAttribute('data-gc-step'), 10) || 1;
      var max = parseInt(stepper.getAttribute('data-gc-max'), 10);
      var min = parseInt(input.getAttribute('min'), 10) || 1;
      var current = parseInt(input.value, 10) || min;
      var next = current + step;
      var card = stepper.closest('[data-gc-product]') || stepper.closest('.gc-pdp__actions') || stepper.parentNode;
      var msg = card ? card.querySelector('[data-gc-stock-msg]') : null;
      if (!isNaN(max) && next > max) {
        if (msg) msg.hidden = false;
        return;
      }
      if (next < min) next = min;
      if (msg) msg.hidden = true;
      input.value = next;
      input.dispatchEvent(new Event('change', { bubbles: true }));
    });
  }

  // ----- Listing filter bottom sheet -----
  function initFilterSheet() {
    var sheet = qs('#gc-filter-sheet');
    var openBtn = qs('#gc-filter-open');
    if (!sheet || !openBtn) return;
    function setOpen(state) {
      sheet.classList.toggle('is-open', state);
      sheet.setAttribute('aria-hidden', state ? 'false' : 'true');
      openBtn.setAttribute('aria-expanded', state ? 'true' : 'false');
      document.body.classList.toggle('gc-drawer-open', state);
    }
    openBtn.addEventListener('click', function () { setOpen(true); });
    qsa('[data-gc-sheet-close]', sheet).forEach(function (el) { el.addEventListener('click', function () { setOpen(false); }); });
    document.addEventListener('keydown', function (e) { if (e.key === 'Escape') setOpen(false); });
  }

  // ----- PDP sticky add-to-cart bar (mobile): lift the FAB while visible -----
  function initStickyBar() {
    var bar = qs('#gc-sticky-bar');
    var fab = qs('#gc-whatsapp-fab');
    if (!bar || !fab) return;
    function sync() {
      var visible = window.getComputedStyle(bar).display !== 'none';
      fab.classList.toggle('gc-fab--lifted', visible);
    }
    sync();
    window.addEventListener('resize', sync);
  }

  // ----- Horizontal scrollers: arrow buttons -----
  function initScrollers() {
    qsa('[data-gc-scroller]').forEach(function (wrap) {
      var track = qs('[data-gc-scroller-track]', wrap);
      if (!track) return;
      qsa('[data-gc-scroller-prev], [data-gc-scroller-next]', wrap).forEach(function (btn) {
        btn.addEventListener('click', function () {
          var dir = btn.hasAttribute('data-gc-scroller-prev') ? -1 : 1;
          track.scrollBy({ left: dir * Math.round(track.clientWidth * 0.8), behavior: 'smooth' });
        });
      });
    });
  }

  // ----- Toasts (flash messages) -----
  // Server flashes (#flash) and JS-response flashes (#js_now_flash, rendered
  // with the NOW_FLASH_ prefix by cart_items / stock_alert responses) are
  // turned into stacked toasts that slide in top-right and auto-dismiss.
  var toastRoot = null;
  function ensureToastRoot() {
    if (!toastRoot || !document.body.contains(toastRoot)) {
      toastRoot = document.createElement('div');
      toastRoot.className = 'gc-toasts';
      toastRoot.setAttribute('aria-live', 'polite');
      document.body.appendChild(toastRoot);
    }
    return toastRoot;
  }

  function gcToast(message, type, opts) {
    opts = opts || {};
    var root = ensureToastRoot();
    var toast = document.createElement('div');
    toast.className = 'gc-toast gc-toast--' + (type || 'info');
    toast.setAttribute('role', type === 'error' ? 'alert' : 'status');
    var icon = { success: '✓', error: '!', warning: '!', info: 'i' }[type] || 'i';
    toast.innerHTML =
      '<span class="gc-toast__icon" aria-hidden="true">' + icon + '</span>' +
      '<div class="gc-toast__body"></div>' +
      '<button type="button" class="gc-toast__close" aria-label="Close">&times;</button>';
    toast.querySelector('.gc-toast__body').textContent = message;
    root.appendChild(toast);
    // next frame → transition in
    requestAnimationFrame(function () { requestAnimationFrame(function () { toast.classList.add('is-in'); }); });

    var timer = null;
    function dismiss() {
      if (!toast.parentNode) return;
      clearTimeout(timer);
      toast.classList.remove('is-in');
      toast.classList.add('is-out');
      setTimeout(function () { if (toast.parentNode) toast.parentNode.removeChild(toast); }, 300);
    }
    toast.querySelector('.gc-toast__close').addEventListener('click', dismiss);
    toast.addEventListener('mouseenter', function () { clearTimeout(timer); });
    toast.addEventListener('mouseleave', function () { timer = setTimeout(dismiss, 2500); });
    timer = setTimeout(dismiss, opts.duration || 6000);
    return toast;
  }
  window.gcToast = gcToast;

  function toastTypeFor(el) {
    var c = el.className || '';
    if (/alert-success/.test(c)) return 'success';
    if (/alert-danger/.test(c)) return 'error';
    if (/alert-warning/.test(c)) return 'warning';
    return 'info';
  }

  // Convert Bootstrap .alert boxes inside a container into toasts and hide them.
  function absorbAlerts(container) {
    if (!container) return;
    qsa('.alert', container).forEach(function (el) {
      if (el.getAttribute('data-gc-toasted')) return;
      el.setAttribute('data-gc-toasted', '1');
      var clone = el.cloneNode(true);
      qsa('button.close, .close', clone).forEach(function (b) { b.parentNode.removeChild(b); });
      var text = clone.textContent.replace(/\s+/g, ' ').trim();
      if (text) gcToast(text, toastTypeFor(el));
      el.style.display = 'none';
    });
  }

  function initFlashToasts() {
    absorbAlerts(qs('#flash'));
    absorbAlerts(qs('#js_now_flash'));
    if (!('MutationObserver' in window)) return;
    // JS responses replace #js_now_flash's innerHTML; the base layout also
    // removes the container after 8s, so keep an empty one around for later
    // responses to target.
    var observer = new MutationObserver(function () {
      var now = qs('#js_now_flash');
      if (!now) {
        now = document.createElement('div');
        now.id = 'js_now_flash';
        document.body.appendChild(now);
      }
      absorbAlerts(now);
    });
    observer.observe(document.body, { childList: true, subtree: true });
  }

  // ----- SweetAlert2 v7 defaults (stock alerts, referral copy, checkout errors) -----
  function initSwalTheme() {
    if (typeof window.Swal !== 'function' || typeof window.Swal.setDefaults !== 'function') return;
    window.Swal.setDefaults({
      customClass: 'gc-swal',
      buttonsStyling: false,
      confirmButtonClass: 'gc-btn gc-btn--primary',
      cancelButtonClass: 'gc-btn gc-btn--ghost',
      animation: false
    });
  }

  document.addEventListener('DOMContentLoaded', function () {
    initSwalTheme();
    initFlashToasts();
    initDrawer();
    initAccountMenu();
    initStickyShadow();
    initSteppers();
    initFilterSheet();
    initStickyBar();
    initScrollers();
  });
})();
