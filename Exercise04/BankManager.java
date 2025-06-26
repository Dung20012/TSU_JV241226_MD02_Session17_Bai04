package Exercise04;

import Database.ConnectDatabase;

import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.SQLException;
import java.sql.Types;

public class BankManager {
    public void transfer(int id_from, int id_to, double amount){
        Connection conn = null;
        CallableStatement stmt = null;

        try {
            conn = ConnectDatabase.getConnection();
            if (conn != null){
                conn.setAutoCommit(false);
                stmt = conn.prepareCall("{call transfer_funds(?,?,?,?)}");
                stmt.setInt(1, id_from);
                stmt.setInt(2, id_to);
                stmt.setDouble(3, amount);
                stmt.registerOutParameter(4, Types.VARCHAR);
                stmt.executeUpdate();
                conn.commit();
                String rs = stmt.getString(4);
                System.out.println(rs);
            }
        }catch (Exception e){
            try {
                if (conn != null){
                    conn.rollback();
                }
            }catch (SQLException ex){
                throw new RuntimeException(ex);
            }
            System.out.println("Chuyển tiền thất bại");
        }finally {
            try {
                if (stmt != null)stmt.close();
                if (conn != null)conn.close();
            }catch (Exception e){
                e.printStackTrace();
            }
        }
    }
}
