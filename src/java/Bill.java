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
import jdk.nashorn.internal.parser.JSONParser;
import org.json.JSONArray;
import org.json.JSONObject;


/**
 *
 * @author winayak
 */
@WebServlet(urlPatterns = {"/Bill"})
public class Bill extends HttpServlet {

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
                    String query = "select * from bill b,purchase_order p where b.po_id = p.id";
                    PreparedStatement ps = con.prepareStatement(query);  
                    try{
                        ResultSet rs = ps.executeQuery();
                        int count = 0;
                        while(rs.next()){     
                            count++;
                            JSONObject obj = new JSONObject();
                            obj.put("id", rs.getInt("bill_id"));
                            obj.put("sno", count);
                            obj.put("billdate", rs.getDate("bill_date"));
                            obj.put("billno", rs.getString("bill_no"));
                            obj.put("poid", rs.getString("b.po_id"));
                            obj.put("poname", rs.getString("p.po_no"));
                            obj.put("paid", rs.getBoolean("paid"));
                            obj.put("tcgst", rs.getFloat("total_cgst"));
                            obj.put("tsgst", rs.getFloat("total_sgst"));
                            obj.put("tigst", rs.getFloat("total_igst"));
                            obj.put("btax", rs.getFloat("before_tax"));
                            obj.put("atax", rs.getFloat("after_tax"));
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
                    int buyer = Integer.parseInt(request.getParameter("buyer"));
                    int consignee = Integer.parseInt(request.getParameter("consignee"));
                    String billno = request.getParameter("billno");
                    int poid = Integer.parseInt(request.getParameter("poid"));
                    
                    float re_charge = 0;
                    float be_tax = 0;
                    float af_tax = 0;
                    float total_discount = 0;
                    float total_cgst = 0;
                    float total_sgst = 0;
                    float total_igst = 0;
                    int mod = 0;                                        
                    String state = request.getParameter("state");
                    String v_no = request.getParameter("v_no");
                    
                    int state_code = Integer.parseInt(request.getParameter("state_code"));
                    Date in_date = Date.valueOf(request.getParameter("in_date"));                    
                    Date po_date = Date.valueOf(request.getParameter("po_date"));
                    Date ch_date = Date.valueOf(request.getParameter("ch_date"));
                    if(request.getParameter("be_tax")!=null && !request.getParameter("be_tax").toString().equals("")){
                        be_tax = Float.parseFloat(request.getParameter("be_tax"));
                    }
                    
                    if(request.getParameter("total_discount")!=null && !request.getParameter("total_discount").toString().equals("")){
                        total_discount = Integer.parseInt(request.getParameter("total_discount"));
                    }
                    if(request.getParameter("af_tax")!=null && !request.getParameter("af_tax").toString().equals("")){
                        af_tax = Float.parseFloat(request.getParameter("af_tax"));
                    }
                    if(request.getParameter("total_cgst")!=null && !request.getParameter("total_cgst").toString().equals("")){
                        total_cgst = Float.parseFloat(request.getParameter("total_cgst"));
                    }
                    if(request.getParameter("total_sgst")!=null && !request.getParameter("total_sgst").toString().equals("")){
                        total_sgst = Float.parseFloat(request.getParameter("total_sgst"));
                    }
                    if(request.getParameter("total_igst")!=null && !request.getParameter("total_igst").toString().equals("")){
                        total_igst = Float.parseFloat(request.getParameter("total_igst"));
                    }
                    String amt_words = request.getParameter("amt_words");
                    if(request.getParameter("re_charge")!=null && !request.getParameter("re_charge").toString().equals("")){
                        re_charge = Float.parseFloat(request.getParameter("re_charge"));
                    }
                    String t_c = request.getParameter("t_c");
                    
                    String query = "insert into bill (buyer_id,consignee_id,bill_no,po_id,state,state_code,mod_id,vehicle_no,bill_date,challan_date,po_date,before_tax,total_discount,after_tax,total_cgst,total_sgst,total_igst,amount_in_words,reverse_charge_tax,terms_conditions,active) values(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)";            
                    
                    PreparedStatement ps = con.prepareStatement(query,Statement.RETURN_GENERATED_KEYS);  
                    ps.setInt(1, buyer);
                    ps.setInt(2, consignee);
                    ps.setString(3, billno);                        
                    ps.setInt(4, poid);                                                           
                    ps.setString(5, state);
                    ps.setInt(6, state_code);
                    if(request.getParameter("mod")!=null && !request.getParameter("mod").toString().equals("")){
                        mod = Integer.parseInt(request.getParameter("mod"));
                        ps.setInt(7, mod);
                    }
                    else{                        
                        ps.setString(7, null);
                    }
                    ps.setString(8, v_no);
                    
                    ps.setDate(9, in_date);
                    ps.setDate(10, ch_date);
                    ps.setDate(11, po_date);
                    ps.setFloat(12, be_tax);
                    ps.setFloat(13, total_discount);
                    ps.setFloat(14, af_tax);
                    ps.setFloat(15, total_cgst);
                    ps.setFloat(16, total_sgst);
                    ps.setFloat(17, total_igst);
                    ps.setString(18, amt_words);
                    ps.setFloat(19, re_charge);
                    ps.setString(20, t_c);
                    ps.setBoolean(21, true);
                    try{
                        int i = ps.executeUpdate();
                        out.println("Bill added!!");
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
                        String query2 = "insert into bill_items (name,code,discount,rate,tax,cgst_rate,cgst_amount,sgst_rate,sgst_amount,igst_rate,igst_amount,uom,total,taxable_value,bill_id,quantity,active) values(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)";            
                        PreparedStatement ps2 = con.prepareStatement(query2);            
                        ps2.setString(1, array.getJSONObject(i).getString("name"));
                        ps2.setInt(2, array.getJSONObject(i).getInt("code"));
                        ps2.setDouble(3, array.getJSONObject(i).getDouble("discount"));
                        ps2.setDouble(4, array.getJSONObject(i).getDouble("rate"));
                        ps2.setDouble(5, array.getJSONObject(i).getDouble("gst"));
                        ps2.setDouble(6, array.getJSONObject(i).getDouble("crate"));
                        ps2.setDouble(7, array.getJSONObject(i).getDouble("camt"));
                        ps2.setDouble(8, array.getJSONObject(i).getDouble("srate"));
                        ps2.setDouble(9, array.getJSONObject(i).getDouble("samt"));
                        ps2.setDouble(10, array.getJSONObject(i).getDouble("irate"));
                        ps2.setDouble(11, array.getJSONObject(i).getDouble("iamt"));
                        ps2.setString(12, array.getJSONObject(i).getString("uom"));
                        ps2.setDouble(13, array.getJSONObject(i).getDouble("tamt"));
                        ps2.setDouble(14, array.getJSONObject(i).getDouble("tval"));
                        ps2.setInt(15, id);
                        ps2.setInt(16, array.getJSONObject(i).getInt("qty"));
                        ps2.setInt(17,1);
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
                    int buyer = Integer.parseInt(request.getParameter("buyer"));
                    int consignee = Integer.parseInt(request.getParameter("consignee"));
                    int poid = Integer.parseInt(request.getParameter("poid"));
                    
                    float re_charge = 0;
                    float be_tax = 0;
                    float af_tax = 0;
                    float total_discount = 0;
                    float total_cgst = 0;
                    float total_sgst = 0;
                    float total_igst = 0;
                    int mod = 0;                                        
                    String state = request.getParameter("state");
                    String v_no = request.getParameter("v_no");
                    
                    int state_code = Integer.parseInt(request.getParameter("state_code"));
                    Date in_date = Date.valueOf(request.getParameter("in_date"));                    
                    Date po_date = Date.valueOf(request.getParameter("po_date"));
                    Date ch_date = Date.valueOf(request.getParameter("ch_date"));
                    if(request.getParameter("be_tax")!=null && !request.getParameter("be_tax").toString().equals("")){
                        be_tax = Float.parseFloat(request.getParameter("be_tax"));
                    }
                    
                    if(request.getParameter("total_discount")!=null && !request.getParameter("total_discount").toString().equals("")){
                        total_discount = Integer.parseInt(request.getParameter("total_discount"));
                    }
                    if(request.getParameter("af_tax")!=null && !request.getParameter("af_tax").toString().equals("")){
                        af_tax = Float.parseFloat(request.getParameter("af_tax"));
                    }
                    if(request.getParameter("total_cgst")!=null && !request.getParameter("total_cgst").toString().equals("")){
                        total_cgst = Float.parseFloat(request.getParameter("total_cgst"));
                    }
                    if(request.getParameter("total_sgst")!=null && !request.getParameter("total_sgst").toString().equals("")){
                        total_sgst = Float.parseFloat(request.getParameter("total_sgst"));
                    }
                    if(request.getParameter("total_igst")!=null && !request.getParameter("total_igst").toString().equals("")){
                        total_igst = Float.parseFloat(request.getParameter("total_igst"));
                    }
                    String amt_words = request.getParameter("amt_words");
                    if(request.getParameter("re_charge")!=null && !request.getParameter("re_charge").toString().equals("")){
                        re_charge = Float.parseFloat(request.getParameter("re_charge"));
                    }
                    String t_c = request.getParameter("t_c");
                    
                    String query = "update bill set buyer_id=?,consignee_id=?,po_id=?,state=?,state_code=?,mod_id=?,vehicle_no=?,bill_date=?,challan_date=?,po_date=?,before_tax=?,total_discount=?,after_tax=?,total_cgst=?,total_sgst=?,total_igst=?,amount_in_words=?,reverse_charge_tax=?,terms_conditions=? where bill_id=?";            
                    PreparedStatement ps = con.prepareStatement(query);  

                    ps.setInt(1, buyer);
                    ps.setInt(2, consignee);                    
                    ps.setInt(3, poid);                                                           
                    ps.setString(4, state);
                    ps.setInt(5, state_code);
                    if(request.getParameter("mod")!=null && !request.getParameter("mod").toString().equals("")){
                        mod = Integer.parseInt(request.getParameter("mod"));
                        ps.setInt(6, mod);
                    }
                    else{                        
                        ps.setString(6, null);
                    }
                    ps.setString(7, v_no);
                    
                    ps.setDate(8, in_date);
                    ps.setDate(9, ch_date);
                    ps.setDate(10, po_date);
                    ps.setFloat(11, be_tax);
                    ps.setFloat(12, total_discount);
                    ps.setFloat(13, af_tax);
                    ps.setFloat(14, total_cgst);
                    ps.setFloat(15, total_sgst);
                    ps.setFloat(16, total_igst);
                    ps.setString(17, amt_words);
                    ps.setFloat(18, re_charge);
                    ps.setString(19, t_c);
                    ps.setInt(20, id);
                    try{
                        int i = ps.executeUpdate();
                        out.println("Bill Updated!!");
                    }
                    catch(Exception e){
                        out.println(e.getMessage());                    
                    }
                    String query3 = "delete from bill_items where bill_id=?";            
                    PreparedStatement ps3 = con.prepareStatement(query3);            
                    ps3.setInt(1,id);
                    ps3.executeUpdate();
                    String json = request.getParameter("json");   
                    JSONArray array = new JSONArray(json);
                    System.out.print(array);
                    for(int i = 0;i<array.length();i++){
                        String query2 = "insert into bill_items (name,code,discount,rate,tax,cgst_rate,cgst_amount,sgst_rate,sgst_amount,igst_rate,igst_amount,uom,total,taxable_value,bill_id,quantity,active) values(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)";            
                        PreparedStatement ps2 = con.prepareStatement(query2);            
                        ps2.setString(1, array.getJSONObject(i).getString("name"));
                        ps2.setInt(2, array.getJSONObject(i).getInt("code"));
                        ps2.setDouble(3, array.getJSONObject(i).getDouble("discount"));
                        ps2.setDouble(4, array.getJSONObject(i).getDouble("rate"));
                        ps2.setDouble(5, array.getJSONObject(i).getDouble("gst"));
                        ps2.setDouble(6, array.getJSONObject(i).getDouble("crate"));
                        ps2.setDouble(7, array.getJSONObject(i).getDouble("camt"));
                        ps2.setDouble(8, array.getJSONObject(i).getDouble("srate"));
                        ps2.setDouble(9, array.getJSONObject(i).getDouble("samt"));
                        ps2.setDouble(10, array.getJSONObject(i).getDouble("irate"));
                        ps2.setDouble(11, array.getJSONObject(i).getDouble("iamt"));
                        ps2.setString(12, array.getJSONObject(i).getString("uom"));
                        ps2.setDouble(13, array.getJSONObject(i).getDouble("tamt"));
                        ps2.setDouble(14, array.getJSONObject(i).getDouble("tval"));
                        ps2.setInt(15, id);
                        ps2.setInt(16, array.getJSONObject(i).getInt("qty"));
                        ps2.setInt(17,1);
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
                    String query3 = "delete from bill_items where bill_id=?";            
                    PreparedStatement ps3 = con.prepareStatement(query3);            
                    ps3.setInt(1,id);
                    ps3.executeUpdate();
                    String query = "delete from bill where bill_id=?";            
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
