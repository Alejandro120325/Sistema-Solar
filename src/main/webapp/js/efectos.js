/* ================================================================
   efectos.js  ·  Mejoras visuales premium
     1) Revelado de elementos al hacer scroll
     2) Contadores numericos animados
     3) Boton flotante "volver arriba"
   ================================================================ */
(function () {
    "use strict";

    /* ---- 1. Revelado al hacer scroll ---------------------------- */
    function initReveal() {
        var objetivos = document.querySelectorAll(
            '.seccion-encabezado, .card-categoria, .franja-stats .stat, ' +
            '.galeria > div, .marco-video, .audio-card, #realidad-aumentada .col-lg-6'
        );
        if (!objetivos.length || !('IntersectionObserver' in window)) return;

        objetivos.forEach(function (el) {
            el.classList.add('reveal-init');
            var ref = el.closest('[class*="col-"]') || el;
            var hermanos = ref.parentElement ? ref.parentElement.children : [];
            var idx = Math.max(0, Array.prototype.indexOf.call(hermanos, ref));
            el.style.transitionDelay = (idx * 0.09) + 's';
        });

        var obs = new IntersectionObserver(function (entradas) {
            entradas.forEach(function (e) {
                if (e.isIntersecting) {
                    e.target.classList.add('reveal-on');
                    obs.unobserve(e.target);
                }
            });
        }, { threshold: 0.14 });

        objetivos.forEach(function (el) { obs.observe(el); });
    }

    /* ---- 2. Contadores animados --------------------------------- */
    function animarContador(el) {
        var destino = parseInt(el.getAttribute('data-contador'), 10) || 0;
        var sufijo = el.getAttribute('data-sufijo') || '';
        var duracion = 1600;
        var inicio = null;

        function paso(t) {
            if (!inicio) inicio = t;
            var avance = Math.min((t - inicio) / duracion, 1);
            var suave = 1 - Math.pow(1 - avance, 3);
            el.textContent = Math.floor(suave * destino) + sufijo;
            if (avance < 1) {
                requestAnimationFrame(paso);
            } else {
                el.textContent = destino + sufijo;
            }
        }
        requestAnimationFrame(paso);
    }

    function initContadores() {
        var nums = document.querySelectorAll('[data-contador]');
        if (!nums.length) return;

        if (!('IntersectionObserver' in window)) {
            nums.forEach(animarContador);
            return;
        }
        var obs = new IntersectionObserver(function (entradas) {
            entradas.forEach(function (e) {
                if (e.isIntersecting) {
                    animarContador(e.target);
                    obs.unobserve(e.target);
                }
            });
        }, { threshold: 0.5 });
        nums.forEach(function (n) { obs.observe(n); });
    }

    /* ---- 3. Boton volver arriba --------------------------------- */
    function initVolverArriba() {
        var btn = document.createElement('button');
        btn.type = 'button';
        btn.className = 'ir-arriba';
        btn.setAttribute('aria-label', 'Volver arriba');
        btn.innerHTML = '<i class="fa fa-angle-up" aria-hidden="true"></i>';
        document.body.appendChild(btn);

        btn.addEventListener('click', function () {
            window.scrollTo({ top: 0, behavior: 'smooth' });
        });
        window.addEventListener('scroll', function () {
            btn.classList.toggle('visible', window.scrollY > 420);
        }, { passive: true });
    }

    document.addEventListener('DOMContentLoaded', function () {
        initReveal();
        initContadores();
        initVolverArriba();
    });
})();
