package com.sistemasolar.modelo;

import java.math.BigDecimal;
import java.sql.Timestamp;

/**
 * Resultado de un alumno en un planeta especifico.
 */
public class Puntuacion {

    private int id;
    private Integer planetaId;
    private Integer usuarioId;
    private String planetaCodigo;
    private String planetaNombre;
    private String usuarioNombre;
    private String email;
    private int puntaje;
    private int puntajeMaximo;
    private BigDecimal progreso;
    private Timestamp fechaRegistro;
    private Timestamp fechaActualizacion;

    public Puntuacion() {
    }

    public Puntuacion(Integer usuarioId, String email, String planetaCodigo,
                      int puntaje, int puntajeMaximo) {
        this.usuarioId = usuarioId;
        this.email = email;
        this.planetaCodigo = planetaCodigo;
        this.puntaje = puntaje;
        this.puntajeMaximo = puntajeMaximo;
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public Integer getPlanetaId() {
        return planetaId;
    }

    public void setPlanetaId(Integer planetaId) {
        this.planetaId = planetaId;
    }

    public Integer getUsuarioId() {
        return usuarioId;
    }

    public void setUsuarioId(Integer usuarioId) {
        this.usuarioId = usuarioId;
    }

    public String getPlanetaCodigo() {
        return planetaCodigo;
    }

    public void setPlanetaCodigo(String planetaCodigo) {
        this.planetaCodigo = planetaCodigo;
    }

    public String getPlanetaNombre() {
        return planetaNombre;
    }

    public void setPlanetaNombre(String planetaNombre) {
        this.planetaNombre = planetaNombre;
    }

    public String getPlaneta() {
        return planetaNombre;
    }

    public String getUsuarioNombre() {
        return usuarioNombre;
    }

    public void setUsuarioNombre(String usuarioNombre) {
        this.usuarioNombre = usuarioNombre;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
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

    public BigDecimal getProgreso() {
        return progreso;
    }

    public void setProgreso(BigDecimal progreso) {
        this.progreso = progreso;
    }

    public Timestamp getFechaRegistro() {
        return fechaRegistro;
    }

    public void setFechaRegistro(Timestamp fechaRegistro) {
        this.fechaRegistro = fechaRegistro;
    }

    public Timestamp getFechaActualizacion() {
        return fechaActualizacion;
    }

    public void setFechaActualizacion(Timestamp fechaActualizacion) {
        this.fechaActualizacion = fechaActualizacion;
    }

    public Timestamp getFechaHora() {
        return fechaActualizacion;
    }
}
