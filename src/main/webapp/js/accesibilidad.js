/* ================================================================
   accesibilidad.js
   Controla el tamaño de texto ajustable (botones A- / A+).
   El sitio mantiene tema oscuro permanente.
   Las preferencias se guardan en el navegador (localStorage).
   ================================================================ */
(function () {
    "use strict";

    var CLAVE_FUENTE = "acc_fuente";
    var CLAVE_TEMA = "educosmos-theme";
    var TEMAS = {
        original: { etiqueta: "Original", clase: "",             swatch: "theme-swatch-original" },
        green:    { etiqueta: "Verde",    clase: "theme-green",  swatch: "theme-swatch-green" },
        cyan:     { etiqueta: "Cyan",     clase: "theme-cyan",   swatch: "theme-swatch-cyan" },
        purple:   { etiqueta: "Morado",   clase: "theme-purple", swatch: "theme-swatch-purple" },
        gold:     { etiqueta: "Dorado",   clase: "theme-gold",   swatch: "theme-swatch-gold" }
    };
    var CLASES_TEMA = ["theme-green", "theme-cyan", "theme-purple", "theme-gold", "theme-magenta", "theme-nebula"];
    var FUENTE_BASE = 16;
    var ESCALA_MIN = 0.9;
    var ESCALA_MAX = 1.15;
    var PASO = 0.05;
    var raiz = document.documentElement;

    function escalaActual() {
        var guardado = parseFloat(localStorage.getItem(CLAVE_FUENTE));
        if (isNaN(guardado)) return 1;

        // Compatibilidad con valores anteriores guardados en pixeles.
        if (guardado > 2) {
            return guardado / FUENTE_BASE;
        }
        return guardado;
    }

    function aplicarFuente(escala) {
        escala = Math.min(ESCALA_MAX, Math.max(ESCALA_MIN, escala));
        escala = Math.round(escala * 100) / 100;
        raiz.style.fontSize = (FUENTE_BASE * escala) + "px";
        localStorage.setItem(CLAVE_FUENTE, escala);
    }

    function normalizarTema(tema) {
        if (tema === "base") return "original";
        if (tema === "nebula") return "purple";
        if (tema === "magenta") return "gold";
        if (tema === "morado") return "purple";
        if (tema === "verde") return "green";
        if (tema === "dorado") return "gold";
        return TEMAS[tema] ? tema : "original";
    }

    function actualizarSelectoresTema(tema) {
        var config = TEMAS[tema];
        document.querySelectorAll("[data-theme-selector]").forEach(function (selector) {
            var etiqueta = selector.querySelector("[data-theme-current-label]");
            var swatch = selector.querySelector("[data-theme-current-swatch]");
            var toggle = selector.querySelector(".theme-toggle");

            if (etiqueta) etiqueta.textContent = config.etiqueta;
            if (swatch) {
                swatch.className = "theme-swatch theme-swatch-current " + config.swatch;
            }
            if (toggle) {
                toggle.setAttribute("aria-label", "Tema visual: " + config.etiqueta);
            }

            selector.querySelectorAll("[data-theme-option]").forEach(function (opcion) {
                var activo = opcion.dataset.themeOption === tema;
                opcion.classList.toggle("is-active", activo);
                opcion.setAttribute("aria-checked", activo ? "true" : "false");
            });
        });
    }

    function cerrarSelectorTema(selector) {
        if (!selector) return;
        selector.classList.remove("is-open");
        var menu = selector.querySelector(".theme-menu");
        var toggle = selector.querySelector(".theme-toggle");
        if (menu) {
            menu.classList.remove("is-open");
            menu.hidden = true;
            menu.setAttribute("hidden", "");
        }
        if (toggle) toggle.setAttribute("aria-expanded", "false");
    }

    function abrirSelectorTema(selector) {
        if (!selector) return;
        cerrarSelectoresTema(selector);
        selector.classList.add("is-open");
        var menu = selector.querySelector(".theme-menu");
        var toggle = selector.querySelector(".theme-toggle");
        if (menu) {
            menu.hidden = false;
            menu.removeAttribute("hidden");
            menu.classList.add("is-open");
        }
        if (toggle) toggle.setAttribute("aria-expanded", "true");
    }

    function selectorTemaAbierto(selector) {
        var menu = selector ? selector.querySelector(".theme-menu") : null;
        return !!(selector && menu && selector.classList.contains("is-open") && !menu.hidden);
    }

    function cerrarSelectoresTema(excepto) {
        document.querySelectorAll("[data-theme-selector]").forEach(function (selector) {
            if (selector === excepto) return;
            cerrarSelectorTema(selector);
        });
    }

    function aplicarTema(tema) {
        tema = normalizarTema(tema);
        var config = TEMAS[tema];
        CLASES_TEMA.forEach(function (clase) { document.body.classList.remove(clase); });
        if (config.clase) document.body.classList.add(config.clase);
        localStorage.setItem(CLAVE_TEMA, tema);
        actualizarSelectoresTema(tema);
    }

    function iniciarAccesibilidad() {
        // Restaurar preferencias guardadas
        aplicarFuente(escalaActual());
        aplicarTema(localStorage.getItem(CLAVE_TEMA));

        var btnMas      = document.getElementById("acc-mas");
        var btnMenos    = document.getElementById("acc-menos");

        if (btnMas)   btnMas.addEventListener("click", function () { aplicarFuente(escalaActual() + PASO); });
        if (btnMenos) btnMenos.addEventListener("click", function () { aplicarFuente(escalaActual() - PASO); });

        document.querySelectorAll("[data-theme-selector]").forEach(function (selector) {
            var toggle = selector.querySelector(".theme-toggle");
            var menu = selector.querySelector(".theme-menu");
            if (!toggle || !menu) return;

            toggle.addEventListener("click", function (e) {
                e.preventDefault();
                e.stopPropagation();

                if (selectorTemaAbierto(selector)) {
                    cerrarSelectorTema(selector);
                } else {
                    abrirSelectorTema(selector);
                }
            });

            selector.querySelectorAll("[data-theme-option]").forEach(function (opcion) {
                opcion.addEventListener("click", function (e) {
                    e.preventDefault();
                    e.stopPropagation();
                    aplicarTema(opcion.dataset.themeOption);
                    cerrarSelectorTema(selector);
                });
            });
        });

        document.addEventListener("click", function (e) {
            if (e.target.closest && e.target.closest("[data-theme-selector]")) return;
            cerrarSelectoresTema();
        });

        document.addEventListener("keydown", function (e) {
            if (e.key === "Escape") cerrarSelectoresTema();
        });
    }

    if (document.readyState === "loading") {
        document.addEventListener("DOMContentLoaded", iniciarAccesibilidad);
    } else {
        iniciarAccesibilidad();
    }

    // --- Mostrar / ocultar contraseña ---
    document.addEventListener("click", function (e) {
        var btn = e.target.closest ? e.target.closest(".toggle-clave") : null;
        if (!btn) return;
        var campo = btn.parentElement.querySelector("input");
        if (!campo) return;
        var icono = btn.querySelector("i");
        var mostrar = (campo.type === "password");
        campo.type = mostrar ? "text" : "password";
        if (icono) icono.className = mostrar ? "fa fa-eye-slash" : "fa fa-eye";
        btn.setAttribute("aria-label", mostrar ? "Ocultar contraseña" : "Mostrar contraseña");
    });
})();
