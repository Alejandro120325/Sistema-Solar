package com.sistemasolar.modelo;

import java.sql.Timestamp;

/**
 * Representa a un usuario del sistema (perfil ADMIN o ESTUDIANTE).
 * El "invitado" no se guarda en base de datos: es quien navega sin sesion.
 */
public class Usuario {

    private int id;
    private String nombreCompleto;
    private String email;
    private String clave;            // hash BCrypt
    private String rol;              // ADMIN | ESTUDIANTE
    private String estado;           // ACTIVO | BLOQUEADO
    private Timestamp fechaRegistro;

    public Usuario() {
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getNombreCompleto() {
        return nombreCompleto;
    }

    public void setNombreCompleto(String nombreCompleto) {
        this.nombreCompleto = nombreCompleto;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public String getClave() {
        return clave;
    }

    public void setClave(String clave) {
        this.clave = clave;
    }

    public String getRol() {
        return rol;
    }

    public void setRol(String rol) {
        this.rol = rol;
    }

    public String getEstado() {
        return estado;
    }

    public void setEstado(String estado) {
        this.estado = estado;
    }

    public Timestamp getFechaRegistro() {
        return fechaRegistro;
    }

    public void setFechaRegistro(Timestamp fechaRegistro) {
        this.fechaRegistro = fechaRegistro;
    }

    /** true si el usuario tiene perfil de administrador. En los JSP: ${usuario.admin} */
    public boolean isAdmin() {
        return "ADMIN".equals(rol);
    }

    /** true si la cuenta esta bloqueada. En los JSP: ${usuario.bloqueado} */
    public boolean isBloqueado() {
        return "BLOQUEADO".equals(estado);
    }
}
