package com.sistemasolar.dao;

import com.sistemasolar.modelo.Bitacora;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Types;
import java.util.ArrayList;
import java.util.List;

/**
 * Acceso a datos de la tabla "bitacora".
 * Aqui se registran los eventos que el administrador debe poder revisar.
 */
public class BitacoraDAO {

    /** Guarda un evento en la bitácora. */
    public void registrar(Bitacora b) {
        String sql = "INSERT INTO bitacora (usuario_id, email, accion, detalle, ip) "
                   + "VALUES (?, ?, ?, ?, ?)";
        try (Connection con = ConexionBD.getConexion();
             PreparedStatement ps = con.prepareStatement(sql)) {

            if (b.getUsuarioId() != null) {
                ps.setInt(1, b.getUsuarioId());
            } else {
                ps.setNull(1, Types.INTEGER);
            }
            ps.setString(2, b.getEmail());
            ps.setString(3, b.getAccion());
            ps.setString(4, b.getDetalle());
            ps.setString(5, b.getIp());
            ps.executeUpdate();

        } catch (SQLException e) {
            // La bitácora no debe romper la app: si falla, solo se informa.
            System.err.println("No se pudo registrar en bitácora: " + e.getMessage());
        }
    }

    /** Atajo para registrar un evento sin construir el objeto a mano. */
    public void registrar(Integer usuarioId, String email, String accion, String detalle, String ip) {
        registrar(new Bitacora(usuarioId, email, accion, detalle, ip));
    }

    /** Lista todos los eventos, del mas reciente al mas antiguo. */
    public List<Bitacora> listarTodas() throws SQLException {
        List<Bitacora> lista = new ArrayList<>();
        String sql = "SELECT * FROM bitacora ORDER BY fecha_hora DESC";
        try (Connection con = ConexionBD.getConexion();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                Bitacora b = new Bitacora();
                b.setId(rs.getInt("id"));
                int uid = rs.getInt("usuario_id");
                b.setUsuarioId(rs.wasNull() ? null : uid);
                b.setEmail(rs.getString("email"));
                b.setAccion(rs.getString("accion"));
                b.setDetalle(rs.getString("detalle"));
                b.setIp(rs.getString("ip"));
                b.setFechaHora(rs.getTimestamp("fecha_hora"));
                lista.add(b);
            }
        }
        return lista;
    }

    /** Cuenta total de eventos registrados. */
    public int contar() throws SQLException {
        String sql = "SELECT COUNT(*) FROM bitacora";
        try (Connection con = ConexionBD.getConexion();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            return rs.next() ? rs.getInt(1) : 0;
        }
    }
}
