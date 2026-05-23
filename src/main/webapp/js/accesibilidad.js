/* ================================================================
   accesibilidad.js
   Controla el tamano de texto ajustable (botones A- / A+).
   El sitio mantiene tema oscuro permanente.
   Las preferencias se guardan en el navegador (localStorage).
   ================================================================ */
(function () {
    "use strict";

    var CLAVE_FUENTE = "acc_fuente";
    var raiz = document.documentElement;

    function fuenteActual() {
        return parseInt(localStorage.getItem(CLAVE_FUENTE) || "16", 10);
    }

    function aplicarFuente(px) {
        px = Math.min(22, Math.max(14, px));
        raiz.style.fontSize = px + "px";
        localStorage.setItem(CLAVE_FUENTE, px);
    }

    document.addEventListener("DOMContentLoaded", function () {
        // Restaurar preferencias guardadas
        aplicarFuente(fuenteActual());

        var btnMas      = document.getElementById("acc-mas");
        var btnMenos    = document.getElementById("acc-menos");

        if (btnMas)   btnMas.addEventListener("click", function () { aplicarFuente(fuenteActual() + 2); });
        if (btnMenos) btnMenos.addEventListener("click", function () { aplicarFuente(fuenteActual() - 2); });
    });

    // --- Mostrar / ocultar contrasena ---
    document.addEventListener("click", function (e) {
        var btn = e.target.closest ? e.target.closest(".toggle-clave") : null;
        if (!btn) return;
        var campo = btn.parentElement.querySelector("input");
        if (!campo) return;
        var icono = btn.querySelector("i");
        var mostrar = (campo.type === "password");
        campo.type = mostrar ? "text" : "password";
        if (icono) icono.className = mostrar ? "fa fa-eye-slash" : "fa fa-eye";
        btn.setAttribute("aria-label", mostrar ? "Ocultar contrasena" : "Mostrar contrasena");
    });
})();
