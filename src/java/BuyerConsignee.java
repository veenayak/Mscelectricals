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
@WebServlet(urlPatterns = {"/BuyerConsignee"})
public class BuyerConsignee extends HttpServlet {

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
            String type = request.getParameter("type");
            String subtype = request.getParameter("subtype");
            Class.forName("com.mysql.cj.jdbc.Driver");  
            Connection con=DriverManager.getConnection("jdbc:mysql://localhost:3306/MSCELECTRICALS?useSSL = false","root","NovoDB123#$");  
            HttpSession session = request.getSession(false);
            JSONArray list = new JSONArray();            
            if(session.getAttribute("user")==null){
                out.println(0);
            }
            else{
                if(type.equals("get")){
                    String query = "select * from buyer_consignee where type=?";
                    PreparedStatement ps = con.prepareStatement(query);  
                    ps.setString(1, subtype);
                    try{
                        ResultSet rs = ps.executeQuery();
                        int count = 0;
                        while(rs.next()){         
                            JSONObject obj = new JSONObject();
                            count++;
                            obj.put("id", rs.getInt("id"));
                            obj.put("sno", count);
                            obj.put("name", rs.getString("name"));
                            obj.put("address", rs.getString("address"));
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
                    String address = request.getParameter("address");        
                    String query = "insert into buyer_consignee (name,address,active,type) values(?,?,?,?)";            
                    PreparedStatement ps = con.prepareStatement(query);            
                    ps.setString(1, item);
                    ps.setString(2, address);
                    ps.setInt(3,1);
                    ps.setString(4,subtype);
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
                    String item_address = request.getParameter("address");      
                    String query = "update buyer_consignee set name=?,address=?,modified_on=null where id=?";            
                    PreparedStatement ps = con.prepareStatement(query);            
                    ps.setString(1, item);
                    ps.setString(2, item_address);
                    ps.setInt(3,id);

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
                    String query = "delete from buyer_consignee where id=?";            
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
