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

  document.addEventListener('DOMContentLoaded', function () {
    initDrawer();
    initAccountMenu();
    initStickyShadow();
    initSteppers();
    initFilterSheet();
    initStickyBar();
    initScrollers();
  });
})();
