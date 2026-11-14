package DAO;

import Model.ConnectSQL;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;

public class DeviceDAO {

    public boolean createInspectionTicket(int deviceId, int batteryHealth, int chargeCycles) throws SQLException {
        String sql = "INSERT INTO inspection_tickets (device_id, battery_health, charge_cycles) VALUES (?, ?, ?)";
        try (Connection conn = ConnectSQL.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, deviceId);
            ps.setInt(2, batteryHealth);
            ps.setInt(3, chargeCycles);
            
            return ps.executeUpdate() > 0;
        }
    }
}