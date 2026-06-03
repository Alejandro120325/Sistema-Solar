package com.sistemasolar.modelo;

import java.sql.Timestamp;

/**
 * Representa un evento registrado en la bitácora del sistema:
 * registros de usuarios nuevos, inicios de sesión e interacciones
 * de los estudiantes con el explorador del Sistema Solar.
 */
public class Bitacora {

    private int id;
    private Integer usuarioId;       // puede ser null
    private String email;
    private String accion;           // REGISTRO, INICIO_SESION, INTERACCION, etc.
    private String detalle;
    private String ip;
    private Timestamp fechaHora;

    public Bitacora() {
    }

    public Bitacora(Integer usuarioId, String email, String accion, String detalle, String ip) {
        this.usuarioId = usuarioId;
        this.email = email;
        this.accion = accion;
        this.detalle = detalle;
        this.ip = ip;
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

    public String getAccion() {
        return accion;
    }

    public void setAccion(String accion) {
        this.accion = accion;
    }

    public String getDetalle() {
        return detalle;
    }

    public void setDetalle(String detalle) {
        this.detalle = detalle;
    }

    public String getIp() {
        return ip;
    }

    public void setIp(String ip) {
        this.ip = ip;
    }

    public Timestamp getFechaHora() {
        return fechaHora;
    }

    public void setFechaHora(Timestamp fechaHora) {
        this.fechaHora = fechaHora;
    }
}
