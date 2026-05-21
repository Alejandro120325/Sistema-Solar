package com.sistemasolar.dao;

import com.sistemasolar.modelo.Usuario;
import org.mindrot.jbcrypt.BCrypt;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;

/**
 * Acceso a datos de la tabla "usuarios".
 * Las contrasenas se guardan SIEMPRE cifradas con BCrypt.
 */
public class UsuarioDAO {

    /** Indica si ya existe un usuario con ese correo. */
    public boolean emailExiste(String email) throws SQLException {
        String sql = "SELECT 1 FROM usuarios WHERE LOWER(email) = LOWER(?)";
        try (Connection con = ConexionBD.getConexion();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, email);
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next();
            }
        }
    }

    /**
     * Inserta un usuario nuevo. La clave que llega en el objeto debe venir
     * EN TEXTO PLANO: aqui se cifra antes de guardarla.
     * @return el id generado, o -1 si fallo.
     */
    public int registrar(Usuario u) throws SQLException {
        String sql = "INSERT INTO usuarios (nombre_completo, email, clave, rol, estado) "
                   + "VALUES (?, ?, ?, ?, ?)";
        try (Connection con = ConexionBD.getConexion();
             PreparedStatement ps = con.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {

            ps.setString(1, u.getNombreCompleto());
            ps.setString(2, u.getEmail());
            ps.setString(3, BCrypt.hashpw(u.getClave(), BCrypt.gensalt()));
            ps.setString(4, u.getRol()   == null ? "ESTUDIANTE" : u.getRol());
            ps.setString(5, u.getEstado() == null ? "ACTIVO"     : u.getEstado());
            ps.executeUpdate();

            try (ResultSet rs = ps.getGeneratedKeys()) {
                if (rs.next()) {
                    return rs.getInt(1);
                }
            }
        }
        return -1;
    }

    /**
     * Comprueba el email + clave. Si las credenciales son correctas
     * devuelve el Usuario; si no, devuelve null.
     */
    public Usuario validarCredenciales(String email, String clavePlana) throws SQLException {
        String sql = "SELECT * FROM usuarios WHERE LOWER(email) = LOWER(?)";
        try (Connection con = ConexionBD.getConexion();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, email);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    Usuario u = mapear(rs);
                    if (BCrypt.checkpw(clavePlana, u.getClave())) {
                        return u;
                    }
                }
            }
        }
        return null;
    }

    public Usuario buscarPorId(int id) throws SQLException {
        String sql = "SELECT * FROM usuarios WHERE id = ?";
        try (Connection con = ConexionBD.getConexion();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return mapear(rs);
                }
            }
        }
        return null;
    }

    /** Lista todos los usuarios, ordenados por fecha de registro (mas recientes primero). */
    public List<Usuario> listarTodos() throws SQLException {
        List<Usuario> lista = new ArrayList<>();
        String sql = "SELECT * FROM usuarios ORDER BY fecha_registro DESC";
        try (Connection con = ConexionBD.getConexion();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                lista.add(mapear(rs));
            }
        }
        return lista;
    }

    /** Actualiza nombre, email, rol y estado. NO toca la contrasena. */
    public boolean actualizar(Usuario u) throws SQLException {
        String sql = "UPDATE usuarios SET nombre_completo = ?, email = ?, rol = ?, estado = ? "
                   + "WHERE id = ?";
        try (Connection con = ConexionBD.getConexion();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, u.getNombreCompleto());
            ps.setString(2, u.getEmail());
            ps.setString(3, u.getRol());
            ps.setString(4, u.getEstado());
            ps.setInt(5, u.getId());
            return ps.executeUpdate() > 0;
        }
    }

    /** Cambia solo la contrasena (recibe la clave en texto plano y la cifra). */
    public boolean actualizarClave(int id, String clavePlana) throws SQLException {
        String sql = "UPDATE usuarios SET clave = ? WHERE id = ?";
        try (Connection con = ConexionBD.getConexion();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, BCrypt.hashpw(clavePlana, BCrypt.gensalt()));
            ps.setInt(2, id);
            return ps.executeUpdate() > 0;
        }
    }

    /** Cambia el estado del usuario: "ACTIVO" o "BLOQUEADO". */
    public boolean cambiarEstado(int id, String estado) throws SQLException {
        String sql = "UPDATE usuarios SET estado = ? WHERE id = ?";
        try (Connection con = ConexionBD.getConexion();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, estado);
            ps.setInt(2, id);
            return ps.executeUpdate() > 0;
        }
    }

    public boolean eliminar(int id) throws SQLException {
        String sql = "DELETE FROM usuarios WHERE id = ?";
        try (Connection con = ConexionBD.getConexion();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, id);
            return ps.executeUpdate() > 0;
        }
    }

    /** Cuenta usuarios; si "campo" no es null filtra por rol o estado. */
    public int contar(String campo, String valor) throws SQLException {
        String sql = "SELECT COUNT(*) FROM usuarios";
        if ("rol".equals(campo) || "estado".equals(campo)) {
            sql += " WHERE " + campo + " = ?";
        }
        try (Connection con = ConexionBD.getConexion();
             PreparedStatement ps = con.prepareStatement(sql)) {
            if (sql.contains("?")) {
                ps.setString(1, valor);
            }
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next() ? rs.getInt(1) : 0;
            }
        }
    }

    /** Convierte una fila del ResultSet en un objeto Usuario. */
    private Usuario mapear(ResultSet rs) throws SQLException {
        Usuario u = new Usuario();
        u.setId(rs.getInt("id"));
        u.setNombreCompleto(rs.getString("nombre_completo"));
        u.setEmail(rs.getString("email"));
        u.setClave(rs.getString("clave"));
        u.setRol(rs.getString("rol"));
        u.setEstado(rs.getString("estado"));
        u.setFechaRegistro(rs.getTimestamp("fecha_registro"));
        return u;
    }
}
