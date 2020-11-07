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
import java.sql.Statement;
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
@WebServlet(urlPatterns = {"/LetterPad"})
public class LetterPad extends HttpServlet {

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
                    String query = "select * from letter_pad";
                    PreparedStatement ps = con.prepareStatement(query);  
                    try{
                        ResultSet rs = ps.executeQuery();
                        int count = 0;
                        while(rs.next()){     
                            count++;
                            JSONObject obj = new JSONObject();
                            obj.put("id", rs.getInt("id"));
                            obj.put("sno", count);
                            obj.put("date", rs.getDate("date"));
                            obj.put("refno", rs.getString("ref_no"));

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
                    
                    String refno = request.getParameter("refno");
                    String name = request.getParameter("name");
                    String address = request.getParameter("address");
                    String subject = request.getParameter("subject");
                    String header = request.getParameter("header");
                    Date date = Date.valueOf(request.getParameter("date"));
                    int cday = Integer.parseInt(request.getParameter("cday"));
                    int ovalid = Integer.parseInt(request.getParameter("ovalid"));
                    Float total = Float.parseFloat(request.getParameter("total"));
                   
                    
                   
                    
                    String query = "insert into letter_pad (ref_no,date,to_name,to_address,subject,header,completion_days,offer_valid_days,total,active) values(?,?,?,?,?,?,?,?,?,?)";            
                    
                    PreparedStatement ps = con.prepareStatement(query,Statement.RETURN_GENERATED_KEYS);  
                    ps.setString(1, refno);
                    ps.setDate(2, date);
                    ps.setString(3, name);                        
                    ps.setString(4, address);      
                    ps.setString(5, subject);      
                    ps.setString(6, header);      
                    
                    ps.setInt(7, cday);
                    ps.setInt(8, ovalid);
                    ps.setFloat(9, total);
                    ps.setBoolean(10, true);
                    try{
                        int i = ps.executeUpdate();
                        out.println("Letter Pad added!!");
                    }
                    catch(Exception e){
                        out.println(e.getMessage());                    
                    }
                    ResultSet rs = ps.getGeneratedKeys();
                    int id = 0;
                    if(rs.next()){
                        id = rs.getInt(1);
                    }
                    String json = request.getParameter("json");   
                    System.out.print(json);
                    JSONArray array = new JSONArray(json);
                    System.out.print(array);
                    for(int i = 0;i<array.length();i++){
                        String query2 = "insert into letter_pad_items (name,code,rate,gst,unit,quantity,active,letter_pad_id,amount) values(?,?,?,?,?,?,?,?,?)";            
                        PreparedStatement ps2 = con.prepareStatement(query2);            
                        ps2.setString(1, array.getJSONObject(i).getString("name"));
                        ps2.setInt(2, array.getJSONObject(i).getInt("code"));
                        ps2.setDouble(3, array.getJSONObject(i).getDouble("rate"));
                        ps2.setInt(4, array.getJSONObject(i).getInt("gst"));
                        ps2.setString(5, array.getJSONObject(i).getString("unit"));
                        ps2.setDouble(6, array.getJSONObject(i).getDouble("qty"));
                        ps2.setBoolean(7, true);
                        ps2.setInt(8, id);
                        ps2.setDouble(9, array.getJSONObject(i).getDouble("amt"));
                        try{
                            int i2 = ps2.executeUpdate();
                        }
                        catch(Exception e){
                            out.println(e.getMessage());                    
                        }
                    } 
                                                 
                }
                else if(type.equals("update")){
                    int id = Integer.parseInt(request.getParameter("id"));
                    String refno = request.getParameter("refno");
                    String name = request.getParameter("name");
                    String address = request.getParameter("address");
                    String subject = request.getParameter("subject");
                    String header = request.getParameter("header");
                    Date date = Date.valueOf(request.getParameter("date"));
                    int cday = Integer.parseInt(request.getParameter("cday"));
                    int ovalid = Integer.parseInt(request.getParameter("ovalid"));
                    Float total = Float.parseFloat(request.getParameter("total"));
                    
                    String query = "update letter_pad set ref_no=?,date=?,to_name=?,to_address=?,subject=?,header=?,completion_days=?,offer_valid_days=?,total=? where id=?";            
                    PreparedStatement ps = con.prepareStatement(query);  

                    ps.setString(1, refno);
                    ps.setDate(2, date);
                    ps.setString(3, name);                        
                    ps.setString(4, address);      
                    ps.setString(5, subject);      
                    ps.setString(6, header);      
                    
                    ps.setInt(7, cday);
                    ps.setInt(8, ovalid);
                    ps.setFloat(9, total);
                    ps.setInt(10, id);
                    try{
                        int i = ps.executeUpdate();
                        out.println("Bill Updated!!");
                    }
                    catch(Exception e){
                        out.println(e.getMessage());                    
                    }
                    String query3 = "delete from letter_pad_items where letter_pad_id=?";            
                    PreparedStatement ps3 = con.prepareStatement(query3);            
                    ps3.setInt(1,id);
                    ps3.executeUpdate();
                    String json = request.getParameter("json");   
                    System.out.print(json);
                    JSONArray array = new JSONArray(json);
                    System.out.print(array);
                    for(int i = 0;i<array.length();i++){
                        String query2 = "insert into letter_pad_items (name,code,rate,gst,unit,quantity,active,letter_pad_id,amount) values(?,?,?,?,?,?,?,?,?)";            
                        PreparedStatement ps2 = con.prepareStatement(query2);            
                        ps2.setString(1, array.getJSONObject(i).getString("name"));
                        ps2.setInt(2, array.getJSONObject(i).getInt("code"));
                        ps2.setDouble(3, array.getJSONObject(i).getDouble("rate"));
                        ps2.setInt(4, array.getJSONObject(i).getInt("gst"));
                        ps2.setString(5, array.getJSONObject(i).getString("unit"));
                        ps2.setDouble(6, array.getJSONObject(i).getDouble("qty"));
                        ps2.setBoolean(7, true);
                        ps2.setInt(8, id);
                        ps2.setDouble(9, array.getJSONObject(i).getDouble("amt"));
                        try{
                            int i2 = ps2.executeUpdate();
                        }
                        catch(Exception e){
                            out.println(e.getMessage());                    
                        }
                    }  
                }
                else if(type.equals("delete")){
                    int id = Integer.parseInt(request.getParameter("id"));
                    String query3 = "delete from letter_pad_items where letter_pad_id=?";            
                    PreparedStatement ps3 = con.prepareStatement(query3);            
                    ps3.setInt(1,id);
                    ps3.executeUpdate();
                    String query = "delete from letter_pad where id=?";            
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
            e.printStackTrace();
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
