/* ================================================================
   accesibilidad.js
   Controla los dos elementos de accesibilidad del sitio:
     1) Tamano de texto ajustable (botones A- / A+)
     2) Modo de alto contraste
   Las preferencias se guardan en el navegador (localStorage).
   ================================================================ */
(function () {
    "use strict";

    var CLAVE_FUENTE = "acc_fuente";
    var CLAVE_CONTRASTE = "acc_contraste";
    var raiz = document.documentElement;

    function fuenteActual() {
        return parseInt(localStorage.getItem(CLAVE_FUENTE) || "16", 10);
    }

    function aplicarFuente(px) {
        px = Math.min(22, Math.max(14, px));
        raiz.style.fontSize = px + "px";
        localStorage.setItem(CLAVE_FUENTE, px);
    }

    function aplicarContraste(activo) {
        document.body.classList.toggle("alto-contraste", activo);
        localStorage.setItem(CLAVE_CONTRASTE, activo ? "1" : "0");
    }

    document.addEventListener("DOMContentLoaded", function () {
        // Restaurar preferencias guardadas
        aplicarFuente(fuenteActual());
        aplicarContraste(localStorage.getItem(CLAVE_CONTRASTE) === "1");

        var btnMas      = document.getElementById("acc-mas");
        var btnMenos    = document.getElementById("acc-menos");
        var btnContraste = document.getElementById("acc-contraste");

        if (btnMas)   btnMas.addEventListener("click", function () { aplicarFuente(fuenteActual() + 2); });
        if (btnMenos) btnMenos.addEventListener("click", function () { aplicarFuente(fuenteActual() - 2); });
        if (btnContraste) btnContraste.addEventListener("click", function () {
            aplicarContraste(!document.body.classList.contains("alto-contraste"));
        });
    });
})();
