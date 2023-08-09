
package model;

import java.sql.*;
import java.util.ArrayList;
import java.util.Date;
import web.AppListener;


public class Movement {

    private long rowId;
    private String clientName; //Nome do Cliente
    private String contNumber; //Número do contêiner
    private String moveType; //Tipo de movimentação
    private Date beginMove; //Data e hora do início
    private Date endMove; //Data e hora do fim
    
    public static String getCreateStatement() {
        return "CREATE TABLE IF NOT EXISTS movements(\n"
                + "    client_name varchar(50) not null\n"
                + "    , cont_number char(11) not null\n"
                + "    , move_type varchar(50) not null\n"     
                + "    , begin_move datetime not null\n"         
                + "    , end_move datetime\n"
                + ")";
    }
    
     public static ArrayList<Movement> getList() throws Exception {
        ArrayList<Movement> list = new ArrayList<>();
        Connection con = AppListener.getConnection();
        Statement s = con.createStatement();
        ResultSet rs = s.executeQuery("SELECT rowid, * FROM movements"
                + " WHERE end_move IS NULL");
        while (rs.next()) {
            Movement lm = new Movement(
                    rs.getLong("rowid"),
                    rs.getString("client_name"),
                    rs.getString("cont_number"),
                    rs.getString("move_type"),
                    rs.getTimestamp("begin_move")
            );
            list.add(lm);
        }
        rs.close();
        s.close();
        con.close();
        return list;
    }
     
    public static ArrayList<Movement> getHistoryList() throws Exception {
        ArrayList<Movement> list = new ArrayList<>();
        Connection con = AppListener.getConnection();
        Statement s = con.createStatement();
        ResultSet rs = s.executeQuery("SELECT rowid, * FROM movements"
                + " WHERE end_move IS NOT NULL ");
        while (rs.next()) {
            Movement lm = new Movement(
                    rs.getLong("rowid"),
                    rs.getString("client_name"),
                    rs.getString("cont_number"),
                    rs.getString("move_type"),
                    rs.getTimestamp("begin_move"),
                    rs.getTimestamp("end_move")
            );
            list.add(lm);
        }
        rs.close();
        s.close();
        con.close();
        return list;
    }
    
    public static void addMovement(String name, String number, String mtype)
        throws Exception {
    String SQL = "INSERT INTO movements VALUES("
            + "?" //client_name
            + ", ?" //cont_number
            + ", ?" //move_type
            + ", ?" //begin_move
            + ", NULL" //end_move
            + ")";
        Connection con = AppListener.getConnection();
        PreparedStatement s = con.prepareStatement(SQL);
        s.setString(1, name);
        s.setString(2, number);
        s.setString(3, mtype);
        s.setTimestamp(4, new Timestamp(new Date().getTime()));
        s.execute();
        s.close();
        con.close();
    }
    
    public static void finishMovement(long rowid)
            throws Exception {
        String SQL = "UPDATE movements"
                + " SET end_move=?"
                + " WHERE rowid =?";
        Connection con = AppListener.getConnection();
        PreparedStatement s = con.prepareStatement(SQL);
        s.setTimestamp(1, new Timestamp(new Date().getTime()));
        s.setLong(2, rowid);
        s.execute();
        s.close();
        con.close();
    }
    
    public Movement(long rowId, String clientName, String contNumber, String moveType, Date beginMove, Date endMove) {
        this.rowId = rowId;
        this.clientName = clientName;
        this.contNumber = contNumber;
        this.moveType = moveType;
        this.beginMove = beginMove;
        this.endMove = endMove;
    }

    public Movement(long rowId, String clientName, String contNumber, String moveType, Date beginMove) {
        this.rowId = rowId;
        this.clientName = clientName;
        this.contNumber = contNumber;
        this.moveType = moveType;
        this.beginMove = beginMove;
    }

    public long getRowId() {
        return rowId;
    }

    public void setRowId(long rowId) {
        this.rowId = rowId;
    }

    public String getClientName() {
        return clientName;
    }

    public void setClientName(String clientName) {
        this.clientName = clientName;
    }

    public String getContNumber() {
        return contNumber;
    }

    public void setContNumber(String contNumber) {
        this.contNumber = contNumber;
    }

    public String getMoveType() {
        return moveType;
    }

    public void setMoveType(String moveType) {
        this.moveType = moveType;
    }

    public Date getBeginMove() {
        return beginMove;
    }

    public void setBeginMove(Date beginMove) {
        this.beginMove = beginMove;
    }

    public Date getEndMove() {
        return endMove;
    }

    public void setEndMove(Date endMove) {
        this.endMove = endMove;
    }
    
    
    
}


