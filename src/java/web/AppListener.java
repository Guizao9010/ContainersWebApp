
package web;

import jakarta.servlet.ServletContextEvent;
import jakarta.servlet.ServletContextListener;
import jakarta.servlet.annotation.WebListener;
import java.math.BigInteger;
import java.security.*;
import java.util.Date;
import java.sql.*;
import model.*;

@WebListener
public class AppListener implements ServletContextListener{
    public static final String CLASS_NAME = "org.sqlite.JDBC";
    public static final String URL = "jdbc:sqlite:containerapp.db";
    public static String initializeLog = "";
    public static Exception exception = null;

    @Override
    public void contextDestroyed(ServletContextEvent sce) {
    }

    @Override
    public void contextInitialized(ServletContextEvent sce) {
        try {
            Connection con = AppListener.getConnection();
            Statement s = con.createStatement();
            s.execute("DELETE FROM users");
            s.execute("DELETE FROM containers");
            s.execute("DELETE FROM movements");
            initializeLog += new Date() + ": Initializing database creation;";
            initializeLog += " Creating Users table if not exists...";
            s.execute(User.getCreateStatement());
            initializeLog += " done;";
            if(User.getUsers().isEmpty()){
                initializeLog += " Adding default users... ";
                User.insertUser("admin", "Administrador", "ADMIN", "1234");
                initializeLog += "Admin added; ";
                User.insertUser("user", "Usuário", "USER", "1234");
                initializeLog += "User added; ";
            }
            initializeLog += " Creating Containers table if not exists...";
            s.execute(Container.getCreateStatement());
            initializeLog += " done; ";
            initializeLog += "Creating Movements table if not exists...";
            s.execute(Movement.getCreateStatement());
            initializeLog += " done.";
            s.close();
            con.close();
        } catch (Exception ex) {
            initializeLog += "Erro: " + ex.getMessage();
        }
    }
    
    public static String getMd5Hash(String text) throws NoSuchAlgorithmException {
        MessageDigest m = MessageDigest.getInstance("MD5");
        m.update(text.getBytes(), 0, text.length());
        return new BigInteger(1, m.digest()).toString();
    }
    
    public static Connection getConnection() throws Exception {
        Class.forName(CLASS_NAME);
        return DriverManager.getConnection(URL);
    }
    
    
}
