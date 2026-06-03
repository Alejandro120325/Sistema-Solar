// js/intro.js
// Pantalla de introducción con fondo espacial estático (sin video).
// La timeline GSAP orquesta título → descripción → botón.
// El botón refleja el progreso de descarga de texturas del sistema solar.

import gsap from 'gsap';
import { audio } from './audio.js';

const loadState = window.SOLAR_EXPLORER_LOAD_STATE = window.SOLAR_EXPLORER_LOAD_STATE || {
    pct: 0,
    ready: false,
    errors: []
};

// =========================================================
// BLOQUEO DE ORIENTACIÓN (solo móviles en portrait)
// La visibilidad la decide el CSS @media; aquí sólo añadimos
// transiciones suaves de GSAP al rotar el dispositivo.
// =========================================================
function setupOrientationLock() {
    const lock = document.getElementById('orientation-lock');
    if (!lock) return;

    // Detecta si el lock está VISIBLE para el usuario (true en portrait móvil)
    function isLockActive() {
        const cs = getComputedStyle(lock);
        return cs.display !== 'none' && !lock.classList.contains('is-hiding');
    }

    // Cuando el usuario rota el dispositivo, animamos el fade-out o fade-in
    function syncOnRotation() {
        const portrait = window.matchMedia('(orientation: portrait)').matches;
        const smallish = window.matchMedia('(max-width: 1024px)').matches;

        if (portrait && smallish) {
            // Entrar al lock: fade-in suave (display lo pone el CSS)
            lock.classList.remove('is-hiding');
            gsap.fromTo(lock, { opacity: 0 }, { opacity: 1, duration: 0.4, ease: 'power2.out' });
        } else if (isLockActive()) {
            // Salir del lock: fade-out GSAP
            gsap.to(lock, {
                opacity: 0,
                duration: 0.6,
                ease: 'power2.in',
                onComplete: () => lock.classList.add('is-hiding')
            });
        }
    }

    window.addEventListener('resize', syncOnRotation);
    window.addEventListener('orientationchange', () => setTimeout(syncOnRotation, 100));
}
setupOrientationLock();

document.addEventListener('DOMContentLoaded', () => {
    const body      = document.body;
    const intro     = document.getElementById('intro-screen');
    const startBtn  = document.getElementById('intro-start');
    const startMain = document.getElementById('intro-start-main');
    const startSub  = document.getElementById('intro-start-sub');
    if (!intro || !startBtn) return;

    body.classList.add('intro-active');

    // Estado inicial — elementos invisibles, listos para GSAP
    gsap.set([
        '.intro-title',
        '.intro-subtitle',
        '.intro-description',
        '.intro-start',
        '.intro-progress-wrap',
        '.intro-hint'
    ], { opacity: 0, y: 20 });
    // El botón parte algo más pequeño para que el 'back.out' tenga overshoot visible
    gsap.set('.intro-start', { scale: 0.88 });

    // ============================================================
    // PROGRESO DE TEXTURAS — se refleja en el botón
    // ============================================================
    let texturesReady = false;

    document.addEventListener('load-progress', (e) => {
        if (texturesReady) return;
        const pct = Math.round(e.detail?.pct ?? 0);
        if (startSub) startSub.textContent = `${pct}%`;
    });

    document.addEventListener('textures-loaded', () => {
        texturesReady = true;
        intro.classList.add('is-ready');
        startBtn.disabled = false;
        startBtn.setAttribute('aria-label', 'Comenzar exploración');
        if (startMain) startMain.textContent = 'COMENZAR';
        if (startSub)  startSub.textContent  = 'EXPLORADOR 3D';
        // Latido sutil para indicar que ya está listo
        gsap.fromTo(startBtn,
            { scale: 1 },
            { scale: 1.06, duration: 0.25, yoyo: true, repeat: 1, ease: 'sine.inOut' }
        );
    });

    function recoverMissedLoadState() {
        if (!loadState.ready || texturesReady) return;
        texturesReady = true;
        intro.classList.add('is-ready');
        startBtn.disabled = false;
        startBtn.setAttribute('aria-label', 'Comenzar exploración');
        if (startMain) startMain.textContent = 'COMENZAR';
        if (startSub)  startSub.textContent  = 'EXPLORADOR 3D';
    }

    document.addEventListener('load-error', (e) => {
        console.error('Error durante la carga del explorador:', e.detail?.url || e.detail);
    });

    if (loadState.ready) {
        recoverMissedLoadState();
    } else if (startSub && loadState.pct > 0) {
        startSub.textContent = `${Math.round(loadState.pct)}%`;
    }

    // ============================================================
    // GSAP TIMELINE — secuencia cinematográfica más rápida
    // Título → Subtítulo → Descripción → Botón → Barra → Hint
    // Total aprox. 1.4s en lugar de 2.8s
    // ============================================================
    const tl = gsap.timeline({
        delay: 0.1,
        defaults: { ease: 'power3.out' },
        onComplete: startIdleMotion
    });

    tl
        .to('.intro-title', {
            opacity: 1, y: 0, duration: 0.7, ease: 'expo.out'
        })
        .to('.intro-subtitle', {
            opacity: 1, y: 0, duration: 0.4
        }, '-=0.40')
        .to('.intro-description', {
            opacity: 1, y: 0, duration: 0.5
        }, '-=0.25')
        .to('.intro-start', {
            opacity: 1, y: 0, scale: 1, duration: 0.55,
            ease: 'back.out(1.7)'
        }, '-=0.15')
        .to('.intro-progress-wrap', {
            opacity: 1, y: 0, duration: 0.3
        }, '-=0.25')
        .to('.intro-hint', {
            opacity: 1, y: 0, duration: 0.4
        }, '-=0.2');

    // ============================================================
    // ANIMACIÓN IDLE — el título flota suavemente y el botón "respira"
    // ============================================================
    function startIdleMotion() {
        gsap.to('.intro-title', {
            y: -8,
            duration: 2.6,
            yoyo: true,
            repeat: -1,
            ease: 'sine.inOut'
        });
        gsap.to('.intro-start', {
            scale: 1.04,
            duration: 1.6,
            yoyo: true,
            repeat: -1,
            ease: 'sine.inOut'
        });
    }

    // ============================================================
    // ENTRAR A LA APLICACIÓN — fade-out coordinado
    // ============================================================
    function enterApp() {
        if (startBtn.disabled) return;

        // Primer gesto del usuario: inicializa el contexto de Web Audio
        audio.ensureRunning();
        // Arranca la música ambiental de inmediato (salvo que el usuario la haya
        // silenciado previamente — preferencia guardada en localStorage)
        if (!audio.musicMuted && !audio.musicPlaying) {
            audio.startMusic();
        }
        audio.sfxWhoosh();

        // Arranca el motor 3D AHORA, antes del fade-out, para que el primer
        // frame esté pintado cuando el intro termine de desaparecer.
        document.dispatchEvent(new CustomEvent('app-start'));

        gsap.to(intro, {
            opacity: 0,
            duration: 0.85,
            ease: 'power2.in',
            onComplete: () => {
                body.classList.remove('intro-active');
                intro.remove();
                startBtn.removeEventListener('click', enterApp);
                document.removeEventListener('keydown', onKey);
            }
        });
    }

    function onKey(e) {
        if ((e.key === 'Enter' || e.key === ' ') && !startBtn.disabled) {
            e.preventDefault();
            enterApp();
        }
    }

    startBtn.addEventListener('click', enterApp);
    document.addEventListener('keydown', onKey);
});
