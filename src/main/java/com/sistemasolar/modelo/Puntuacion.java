package com.sistemasolar.modelo;

import java.sql.Timestamp;

/**
 * Representa el resultado que obtiene un alumno al jugar el minijuego
 * de un planeta. Ejemplo: planeta "Tierra", puntaje 5, maximo 8.
 */
public class Puntuacion {

    private int id;
    private Integer usuarioId;
    private String email;
    private String planeta;
    private int puntaje;
    private int puntajeMaximo;
    private Timestamp fechaHora;

    public Puntuacion() {
    }

    public Puntuacion(Integer usuarioId, String email, String planeta,
                      int puntaje, int puntajeMaximo) {
        this.usuarioId = usuarioId;
        this.email = email;
        this.planeta = planeta;
        this.puntaje = puntaje;
        this.puntajeMaximo = puntajeMaximo;
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public Integer getUsuarioId() {
        return usuarioId;
    }

    public void setUsuarioId(Integer usuarioId) {
        this.usuarioId = usuarioId;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public String getPlaneta() {
        return planeta;
    }

    public void setPlaneta(String planeta) {
        this.planeta = planeta;
    }

    public int getPuntaje() {
        return puntaje;
    }

    public void setPuntaje(int puntaje) {
        this.puntaje = puntaje;
    }

    public int getPuntajeMaximo() {
        return puntajeMaximo;
    }

    public void setPuntajeMaximo(int puntajeMaximo) {
        this.puntajeMaximo = puntajeMaximo;
    }

    public Timestamp getFechaHora() {
        return fechaHora;
    }

    public void setFechaHora(Timestamp fechaHora) {
        this.fechaHora = fechaHora;
    }
}
