package com.sistemasolar.dao;

import com.sistemasolar.modelo.Planeta;
import com.sistemasolar.modelo.Puntuacion;

import java.math.BigDecimal;
import java.math.RoundingMode;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Types;
import java.util.ArrayList;
import java.util.List;

/**
 * Acceso a planetas y puntuaciones por planeta.
 */
public class PuntuacionDAO {

    /**
     * Guarda o actualiza la puntuacion de un alumno en un planeta.
     * La llave unica usuario_id + planeta_id evita duplicados.
     */
    public void registrar(Puntuacion p) {
        String sql =
            "INSERT INTO puntuaciones_planeta " +
            "(usuario_id, planeta_id, puntaje, puntaje_maximo, progreso) " +
            "SELECT ?, pl.id, ?, ?, ? " +
            "FROM planetas pl " +
            "WHERE LOWER(pl.codigo) = LOWER(?) OR LOWER(pl.nombre) = LOWER(?) " +
            "ON CONFLICT (usuario_id, planeta_id) DO UPDATE SET " +
            "puntaje = EXCLUDED.puntaje, " +
            "puntaje_maximo = EXCLUDED.puntaje_maximo, " +
            "progreso = EXCLUDED.progreso, " +
            "fecha_actualizacion = NOW()";

        try (Connection con = ConexionBD.getConexion();
             PreparedStatement ps = con.prepareStatement(sql)) {

            if (p.getUsuarioId() != null) {
                ps.setInt(1, p.getUsuarioId());
            } else {
                ps.setNull(1, Types.INTEGER);
            }
            ps.setInt(2, p.getPuntaje());
            ps.setInt(3, p.getPuntajeMaximo());
            ps.setBigDecimal(4, calcularProgreso(p.getPuntaje(), p.getPuntajeMaximo()));
            ps.setString(5, p.getPlanetaCodigo());
            ps.setString(6, p.getPlanetaCodigo());
            ps.executeUpdate();

        } catch (SQLException e) {
            System.err.println("No se pudo registrar la puntuacion: " + e.getMessage());
        }
    }

    /** Obtener todos los planetas activos. */
    public List<Planeta> listarPlanetas() throws SQLException {
        List<Planeta> lista = new ArrayList<>();
        String sql = "SELECT id, codigo, nombre, descripcion, estado, orden " +
                     "FROM planetas WHERE estado = 'ACTIVO' ORDER BY orden";
        try (Connection con = ConexionBD.getConexion();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                Planeta p = new Planeta();
                p.setId(rs.getInt("id"));
                p.setCodigo(rs.getString("codigo"));
                p.setNombre(rs.getString("nombre"));
                p.setDescripcion(rs.getString("descripcion"));
                p.setEstado(rs.getString("estado"));
                p.setOrden(rs.getInt("orden"));
                lista.add(p);
            }
        }
        return lista;
    }

    /** Lista usuarios y puntuaciones por planeta. */
    public List<Puntuacion> listarTodas() throws SQLException {
        String sql =
            "SELECT pp.*, p.codigo AS planeta_codigo, p.nombre AS planeta_nombre, " +
            "u.nombre_completo AS usuario_nombre, u.email " +
            "FROM puntuaciones_planeta pp " +
            "JOIN planetas p ON p.id = pp.planeta_id " +
            "JOIN usuarios u ON u.id = pp.usuario_id " +
            "ORDER BY pp.fecha_actualizacion DESC";
        return consultarLista(sql);
    }

    /** Ranking de un planeta ordenado por puntuacion descendente. */
    public List<Puntuacion> rankingPorPlaneta(String codigoPlaneta) throws SQLException {
        String sql =
            "SELECT pp.*, p.codigo AS planeta_codigo, p.nombre AS planeta_nombre, " +
            "u.nombre_completo AS usuario_nombre, u.email " +
            "FROM puntuaciones_planeta pp " +
            "JOIN planetas p ON p.id = pp.planeta_id " +
            "JOIN usuarios u ON u.id = pp.usuario_id " +
            "WHERE LOWER(p.codigo) = LOWER(?) OR LOWER(p.nombre) = LOWER(?) " +
            "ORDER BY pp.puntaje DESC, pp.fecha_actualizacion ASC";
        try (Connection con = ConexionBD.getConexion();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, codigoPlaneta);
            ps.setString(2, codigoPlaneta);
            return consultarConPreparedStatement(ps);
        }
    }

    /** Puntuacion de un alumno especifico dentro de un planeta. */
    public Puntuacion buscarPuntuacionUsuarioPlaneta(int usuarioId, String codigoPlaneta) throws SQLException {
        String sql =
            "SELECT pp.*, p.codigo AS planeta_codigo, p.nombre AS planeta_nombre, " +
            "u.nombre_completo AS usuario_nombre, u.email " +
            "FROM puntuaciones_planeta pp " +
            "JOIN planetas p ON p.id = pp.planeta_id " +
            "JOIN usuarios u ON u.id = pp.usuario_id " +
            "WHERE pp.usuario_id = ? AND (LOWER(p.codigo) = LOWER(?) OR LOWER(p.nombre) = LOWER(?))";
        try (Connection con = ConexionBD.getConexion();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, usuarioId);
            ps.setString(2, codigoPlaneta);
            ps.setString(3, codigoPlaneta);
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next() ? mapear(rs) : null;
            }
        }
    }

    /** Cuenta total de puntuaciones registradas. */
    public int contar() throws SQLException {
        String sql = "SELECT COUNT(*) FROM puntuaciones_planeta";
        try (Connection con = ConexionBD.getConexion();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            return rs.next() ? rs.getInt(1) : 0;
        }
    }

    private List<Puntuacion> consultarLista(String sql) throws SQLException {
        try (Connection con = ConexionBD.getConexion();
             PreparedStatement ps = con.prepareStatement(sql)) {
            return consultarConPreparedStatement(ps);
        }
    }

    private List<Puntuacion> consultarConPreparedStatement(PreparedStatement ps) throws SQLException {
        List<Puntuacion> lista = new ArrayList<>();
        try (ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                lista.add(mapear(rs));
            }
        }
        return lista;
    }

    private Puntuacion mapear(ResultSet rs) throws SQLException {
        Puntuacion p = new Puntuacion();
        p.setId(rs.getInt("id"));
        p.setPlanetaId(rs.getInt("planeta_id"));
        p.setUsuarioId(rs.getInt("usuario_id"));
        p.setPlanetaCodigo(rs.getString("planeta_codigo"));
        p.setPlanetaNombre(rs.getString("planeta_nombre"));
        p.setUsuarioNombre(rs.getString("usuario_nombre"));
        p.setEmail(rs.getString("email"));
        p.setPuntaje(rs.getInt("puntaje"));
        p.setPuntajeMaximo(rs.getInt("puntaje_maximo"));
        p.setProgreso(rs.getBigDecimal("progreso"));
        p.setFechaRegistro(rs.getTimestamp("fecha_registro"));
        p.setFechaActualizacion(rs.getTimestamp("fecha_actualizacion"));
        return p;
    }

    private BigDecimal calcularProgreso(int puntaje, int maximo) {
        int divisor = Math.max(maximo, 1);
        return BigDecimal.valueOf(puntaje)
                .multiply(BigDecimal.valueOf(100))
                .divide(BigDecimal.valueOf(divisor), 2, RoundingMode.HALF_UP);
    }
}
