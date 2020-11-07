/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */

import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.Date;
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
@WebServlet(urlPatterns = {"/PurchaseOrder"})
public class PurchaseOrder extends HttpServlet {

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
            Class.forName("com.mysql.cj.jdbc.Driver");  
            Connection con=DriverManager.getConnection("jdbc:mysql://localhost:3306/MSCELECTRICALS?useSSL = false","root","NovoDB123#$");  
            HttpSession session = request.getSession(false);
            JSONArray list = new JSONArray();
            if(session.getAttribute("user")==null){
                out.println(0);
            }
            else{
                if(type.equals("get")){
                    String query = "select * from purchase_order  p,buyer_consignee b where p.consignee_id = b.id";
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
                            obj.put("pono", rs.getString("po_no"));
                            obj.put("podate", rs.getDate("po_date"));
                            obj.put("dpdate", rs.getDate("dp_upto_date"));
                            obj.put("podesc", rs.getString("po_description"));
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
                    String po_no = request.getParameter("pono");
                    Date po_date = Date.valueOf(request.getParameter("po_date"));      
                    Date dp_date = Date.valueOf(request.getParameter("dp_date"));        
                    String desc = request.getParameter("desc");        
                    int consignee = Integer.parseInt(request.getParameter("consignee"));        
                    String query = "insert into purchase_order (po_no,po_date,dp_upto_date,po_description,consignee_id,active) values(?,?,?,?,?,?)";            
                    PreparedStatement ps = con.prepareStatement(query);  
                    ps.setString(1, po_no);
                    ps.setDate(2, po_date);
                    ps.setDate(3, dp_date);
                    ps.setString(4, desc);
                    ps.setInt(5, consignee);
                    ps.setInt(6, 1);
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
                    String po_no = request.getParameter("po_no");                
                    Date po_date = Date.valueOf(request.getParameter("po_date"));      
                    Date dp_date = Date.valueOf(request.getParameter("dp_date"));          
                    String desc = request.getParameter("desc");        
                    int consignee = Integer.parseInt(request.getParameter("consignee"));            
                    String query = "update purchase_order set po_no=?,po_date=?,dp_upto_date=?,po_description=?,consignee_id=?,modified_on=null where id=?";            
                    PreparedStatement ps = con.prepareStatement(query);           
                    ps.setString(1, po_no);
                    ps.setDate(2, po_date);
                    ps.setDate(3, dp_date);
                    ps.setString(4, desc);
                    ps.setInt(5, consignee);
                    ps.setInt(6,id);

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
                    String query3 = "delete from po_items where po_id=?";            
                    PreparedStatement ps3 = con.prepareStatement(query3);            
                    ps3.setInt(1,id);
                    ps3.executeUpdate();
                    String query = "delete from purchase_order where id=?";            
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
