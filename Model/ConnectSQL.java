package Model;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class ConnectSQL {

    public static Connection getConnection() {
        Connection conn = null;
        try {
            Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
           String url = "jdbc:sqlserver://localhost:1433;databaseName=iPhoneQCStore;encrypt=true;trustServerCertificate=true;";
            String user = "sa";
            String password = "123456789";
            conn = DriverManager.getConnection(url, user, password);
            System.out.println("Kết nối CSDL iPhoneQCStore thành công!");
        } catch (ClassNotFoundException | SQLException e) {
            System.out.println("Kết nối CSDL thất bại!");
            e.printStackTrace();
        }
        return conn;
    }

    public static void main(String[] args) {
        getConnection();
    }
}