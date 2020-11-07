/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */

import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import org.json.JSONArray;
import org.json.JSONObject;

/**
 *
 * @author winayak
 */
@WebServlet(urlPatterns = {"/ModeOfDispatch"})
public class ModeOfDispatch extends HttpServlet {

    /**
     * Processes requests for both HTTP <code>GET</code> and <code>POST</code>
     * methods.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        try (PrintWriter out = response.getWriter()) {
            /* TODO output your page here. You may use following sample code. */
            String type = request.getParameter("type");
            Class.forName("com.mysql.cj.jdbc.Driver");  
            Connection con=DriverManager.getConnection("jdbc:mysql://localhost:3306/MSCELECTRICALS?useSSL = false","root","NovoDB123#$");  
            HttpSession session = request.getSession(false);
            JSONArray list = new JSONArray();
            if(session.getAttribute("user")==null){
                out.println(0);
            }
            else{
                if(type.equals("get")){
                    String query = "select * from mode_of_dispatch";
                    PreparedStatement ps = con.prepareStatement(query);  
                    try{
                        ResultSet rs = ps.executeQuery();
                        String res = "";
                        int count = 0;
                        while(rs.next()){                        
                            count++;
                            JSONObject obj = new JSONObject();
                            obj.put("id", rs.getInt("id"));
                            obj.put("sno", count);
                            obj.put("name", rs.getString("name"));
                            list.put(obj);                            
                        }                
                        out.println(list);
                    }
                    catch(Exception e){
                        out.println(e.getMessage());                    
                    }
                    finally{
                        con.close();    
                    }                                  
                }
                else if(type.equals("add")){
                    String item = request.getParameter("item");      
                    String query = "insert into mode_of_dispatch (name,active) values(?,?)";            
                    PreparedStatement ps = con.prepareStatement(query);            
                    ps.setString(1, item);
                    ps.setInt(2,1);
                    try{
                        int i = ps.executeUpdate();
                        out.println(i);
                    }
                    catch(Exception e){
                        out.println(e.getMessage());                    
                    }
                    finally{
                        con.close();    
                    }                                
                }
                else if(type.equals("update")){
                    int id = Integer.parseInt(request.getParameter("id"));              
                    String item = request.getParameter("item");
                    String query = "update mode_of_dispatch set name=?,modified_on=null where id=?";            
                    PreparedStatement ps = con.prepareStatement(query);            
                    ps.setString(1, item);
                    ps.setInt(2,id);
                    try{
                        int i = ps.executeUpdate();
                        out.println(i);
                    }
                    catch(Exception e){
                        out.println(e.getMessage());                    
                    }
                    finally{
                        con.close();    
                    }  
                }
                else if(type.equals("delete")){
                    int id = Integer.parseInt(request.getParameter("id"));     
                    String query = "delete from mode_of_dispatch where id=?";            
                    PreparedStatement ps = con.prepareStatement(query);            
                    ps.setInt(1,id);
                    try{
                        int i = ps.executeUpdate();
                        out.println(i);
                    }
                    catch(Exception e){
                        out.println(e.getMessage());                    
                    }
                    finally{
                        con.close();    
                    }  
                }
            }
            
        }
        catch(Exception e){
            response.getWriter().println(e.toString());
        }        
    }

    // <editor-fold defaultstate="collapsed" desc="HttpServlet methods. Click on the + sign on the left to edit the code.">
    /**
     * Handles the HTTP <code>GET</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    /**
     * Handles the HTTP <code>POST</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    /**
     * Returns a short description of the servlet.
     *
     * @return a String containing servlet description
     */
    @Override
    public String getServletInfo() {
        return "Short description";
    }// </editor-fold>

}
