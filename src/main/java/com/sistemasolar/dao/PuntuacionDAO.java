package com.sistemasolar.dao;

import com.sistemasolar.modelo.Puntuacion;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Types;
import java.util.ArrayList;
import java.util.List;

/**
 * Acceso a datos de la tabla "puntuaciones": los resultados que
 * obtienen los alumnos en los minijuegos de los planetas.
 */
public class PuntuacionDAO {

    /** Guarda una puntuacion nueva. */
    public void registrar(Puntuacion p) {
        String sql = "INSERT INTO puntuaciones (usuario_id, email, planeta, puntaje, puntaje_maximo) "
                   + "VALUES (?, ?, ?, ?, ?)";
        try (Connection con = ConexionBD.getConexion();
             PreparedStatement ps = con.prepareStatement(sql)) {

            if (p.getUsuarioId() != null) {
                ps.setInt(1, p.getUsuarioId());
            } else {
                ps.setNull(1, Types.INTEGER);
            }
            ps.setString(2, p.getEmail());
            ps.setString(3, p.getPlaneta());
            ps.setInt(4, p.getPuntaje());
            ps.setInt(5, p.getPuntajeMaximo());
            ps.executeUpdate();

        } catch (SQLException e) {
            System.err.println("No se pudo registrar la puntuacion: " + e.getMessage());
        }
    }

    /** Lista todas las puntuaciones, de la mas reciente a la mas antigua. */
    public List<Puntuacion> listarTodas() throws SQLException {
        List<Puntuacion> lista = new ArrayList<>();
        String sql = "SELECT * FROM puntuaciones ORDER BY fecha_hora DESC";
        try (Connection con = ConexionBD.getConexion();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                Puntuacion p = new Puntuacion();
                p.setId(rs.getInt("id"));
                int uid = rs.getInt("usuario_id");
                p.setUsuarioId(rs.wasNull() ? null : uid);
                p.setEmail(rs.getString("email"));
                p.setPlaneta(rs.getString("planeta"));
                p.setPuntaje(rs.getInt("puntaje"));
                p.setPuntajeMaximo(rs.getInt("puntaje_maximo"));
                p.setFechaHora(rs.getTimestamp("fecha_hora"));
                lista.add(p);
            }
        }
        return lista;
    }

    /** Cuenta total de partidas jugadas registradas. */
    public int contar() throws SQLException {
        String sql = "SELECT COUNT(*) FROM puntuaciones";
        try (Connection con = ConexionBD.getConexion();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            return rs.next() ? rs.getInt(1) : 0;
        }
    }
}
