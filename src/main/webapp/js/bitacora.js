/* ================================================================
   bitacora.js
   Envia al servidor las interacciones del estudiante dentro del
   explorador 3D para que queden registradas en la bitacora del
   administrador. No modifica el motor 3D: solo escucha eventos.
   ================================================================ */
(function () {
    "use strict";

    var ctx = window.CONTEXT_PATH || "";

    var NOMBRES = {
        sun: "el Sol", mercury: "Mercurio", venus: "Venus", earth: "la Tierra",
        mars: "Marte", jupiter: "Jupiter", saturn: "Saturno", uranus: "Urano",
        neptune: "Neptuno", pluto: "Pluton"
    };

    var ACCIONES = {
        visit: "Visito en 3D",
        encyclopedia: "Leyo la enciclopedia de",
        structure: "Exploro la estructura de",
        game: "Jugo el minijuego de"
    };

    function registrar(detalle) {
        try {
            var datos = new URLSearchParams();
            datos.set("detalle", detalle);
            fetch(ctx + "/interaccion", {
                method: "POST",
                headers: { "Content-Type": "application/x-www-form-urlencoded" },
                body: datos.toString()
            });
        } catch (e) {
            /* si falla el registro, la experiencia 3D no se interrumpe */
        }
    }

    function planetaActual() {
        var sel = document.querySelector('input[name="planet"]:checked');
        return sel ? (NOMBRES[sel.id] || sel.id) : "el Sistema Solar";
    }

    // El estudiante selecciona un planeta en el menu lateral
    document.addEventListener("change", function (e) {
        if (e.target && e.target.matches('input[name="planet"]')) {
            registrar("Selecciono " + (NOMBRES[e.target.id] || e.target.id));
        }
    });

    // El estudiante abre una accion del panel (visita, enciclopedia, etc.)
    document.addEventListener("click", function (e) {
        var btn = e.target.closest ? e.target.closest(".scifi-btn[data-action]") : null;
        if (btn) {
            var accion = ACCIONES[btn.dataset.action] || "Interactuo con";
            registrar(accion + " " + planetaActual());
        }
    });

    // Marca de ingreso al explorador
    registrar("Ingreso al explorador del Sistema Solar");
})();
