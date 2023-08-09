
package model;

import java.sql.*;
import java.util.ArrayList;
import web.AppListener;


public class Container {
    private long rowId;
    private String client; //Cliente
    private String contNumber; //Número do contêiner
    private String type; //Tipo
    private String status; //Status
    private String category; //Categoria
    
    public static String getCreateStatement(){
    return "CREATE TABLE IF NOT EXISTS containers(\n"    
                + "    client_name varchar(50) not null\n"     
                + "    , cont_number char(11) not null\n"      
                + "    , type number(3) not null\n"    
                + "    , status varchar(5) not null\n"        
                + "    , category varchar(11) not null\n"
                + ")";
    }
    
    public static ArrayList<Container> getList() throws Exception {
        ArrayList<Container> list = new ArrayList<>();
        Connection con = AppListener.getConnection();
        Statement s = con.createStatement();
        ResultSet rs = s.executeQuery("SELECT rowid, * FROM containers");
        while (rs.next()) {
            Container lc = new Container(
                     rs.getLong("rowid"),
                     rs.getString("client_name"),
                     rs.getString("cont_number"),
                     rs.getString("type"),
                     rs.getString("status"),
                     rs.getString("category")
            );
            list.add(lc);
        }
        rs.close();
        s.close();
        con.close();
        return list;
    }
    
    public static void addContainer(String name, String number, String type, String status, String cat)
        throws Exception {
    String SQL = "INSERT INTO containers VALUES("
            + "?" //client_name
            + ", ?" //cont_number
            + ", ?" //type
            + ", ?" //status
            + ", ?" //category
            + ")";
        Connection con = AppListener.getConnection();
        PreparedStatement s = con.prepareStatement(SQL);
        s.setString(1, name);
        s.setString(2, number);
        s.setString(3, type);
        s.setString(4, status);
        s.setString(5, cat);
        s.execute();
        s.close();
        con.close();
    }
    
    public static void deleteContainer(long rowId) throws Exception{
        Connection con = AppListener.getConnection();
        String sql = "DELETE FROM containers WHERE rowid = ?";
        PreparedStatement s = con.prepareStatement(sql);
        s.setLong(1, rowId);
        s.execute();
        s.close();
        con.close();
    }
    
     public Container(long rowId, String client, String contNumber, String type, String status, String category) {
        this.rowId = rowId;
        this.client = client;
        this.contNumber = contNumber;
        this.type = type;
        this.status = status;
        this.category = category;
    }

    public long getRowId() {
        return rowId;
    }

    public void setRowId(long rowId) {
        this.rowId = rowId;
    }

    public String getClient() {
        return client;
    }

    public void setClient(String client) {
        this.client = client;
    }

    public String getContNumber() {
        return contNumber;
    }

    public void setContNumber(String contNumber) {
        this.contNumber = contNumber;
    }

    public String getType() {
        return type;
    }

    public void setType(String type) {
        this.type = type;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public String getCategory() {
        return category;
    }

    public void setCategory(String category) {
        this.category = category;
    }
}


