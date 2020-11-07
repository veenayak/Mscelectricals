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
@WebServlet(urlPatterns = {"/BillDetails"})
public class BillDetails extends HttpServlet {

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
            int id  = Integer.parseInt(request.getParameter("id"));
            HttpSession session = request.getSession(false);     
            JSONArray list = new JSONArray();            

            if(session.getAttribute("user")==null){
                out.println(0);
            }
            else{
                String query = "select * from bill where bill_id=?";
                PreparedStatement ps = con.prepareStatement(query);  
                ps.setInt(1, id);
                try{
                    ResultSet rs = ps.executeQuery();
                    JSONObject obj = new JSONObject();
                    while(rs.next()){                             
                        obj.put("id", rs.getInt("bill_id"));
                        obj.put("buyer", rs.getInt("buyer_id"));
                        obj.put("consignee", rs.getInt("consignee_id"));
                        obj.put("billdate", rs.getDate("bill_date"));
                        obj.put("billno", rs.getString("bill_no"));
                        obj.put("pono", rs.getString("po_id"));
                        obj.put("podate", rs.getDate("po_date"));
                        obj.put("challanno", rs.getString("bill_no"));
                        obj.put("state", rs.getString("state"));
                        obj.put("scode", rs.getString("state_code"));
                        obj.put("vno", rs.getString("vehicle_no"));
                        obj.put("mod", rs.getInt("mod_id"));
                        obj.put("challandate", rs.getDate("challan_date"));
                        obj.put("betax", rs.getFloat("before_tax"));
                        obj.put("aftax", rs.getFloat("after_tax"));
                        obj.put("paid", rs.getBoolean("paid"));
                        obj.put("tdisc", rs.getFloat("total_discount"));
                        obj.put("tc", rs.getString("terms_conditions"));
                        obj.put("rcharge", rs.getFloat("reverse_charge_tax"));   
                        obj.put("amtwords", rs.getString("amount_in_words"));   
                        obj.put("tcgst", rs.getFloat("total_cgst"));   
                        obj.put("tsgst", rs.getFloat("total_sgst"));   
                        obj.put("tigst", rs.getFloat("total_igst"));   
                        
                    }                
                    list.put(obj);                    
                }
                catch(Exception e){
                    out.println(e.getMessage());                    
                }
                String query2 = "select * from bill_items where bill_id=?";
                PreparedStatement ps2 = con.prepareStatement(query2);  
                ps2.setInt(1, id);
                try{
                    ResultSet rs = ps2.executeQuery();
                    JSONArray list2 = new JSONArray();            

                    int count =0;
                    while(rs.next()){       
                        JSONObject obj = new JSONObject();
                        count++;
                        obj.put("sno", count);
                        obj.put("name", rs.getString("name"));
                        obj.put("code", rs.getInt("code"));
                        obj.put("uom", rs.getString("uom"));
                        obj.put("tax", rs.getInt("tax"));
                        obj.put("rate", rs.getInt("rate"));
                        obj.put("camt", rs.getFloat("cgst_amount"));
                        obj.put("crate", rs.getFloat("cgst_rate"));
                        obj.put("samt", rs.getFloat("sgst_amount"));
                        obj.put("srate", rs.getFloat("sgst_rate"));
                        obj.put("iamt", rs.getFloat("igst_amount"));
                        obj.put("irate", rs.getFloat("igst_rate"));
                        obj.put("discount", rs.getFloat("discount"));
                        obj.put("qty", rs.getInt("quantity"));

                        
                        list2.put(obj);
                    }        
                    list.put(list2);
                    out.println(list);
                }   
                catch(Exception e){
                    out.println(e.getMessage());                    
                }
                finally{
                    con.close();    
                }  
            }
        }
        catch(Exception e){
            e.printStackTrace();
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
