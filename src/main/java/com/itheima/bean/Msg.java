package com.itheima.bean;

import java.util.HashMap;
import java.util.Map;

/**
 * @author 19798
 * @version 1.0
 * @ClassName Msg
 * @description 通用的返回json数据的类
 * @date 2020/7/21 22:04
 */
public class Msg {
//    code表示状态码
    private int code;
// msg就是提示信息
    private String msg;

//    返回给浏览器时包含的用户信息
    private Map<String,Object> extend=new HashMap<>();

    public static Msg success(){
        Msg msg = new Msg();
        msg.setCode(100);
        msg.setMsg("处理成功");
        return msg;
    }

    public static Msg fail(){
        Msg msg = new Msg();
        msg.setCode(200);
        msg.setMsg("处理失败");
        return msg;
    }
//给Msg添加一个add方法，返回的是一个Msg对象，这样就能链式操作,Msg对象始终只有一个，但能存多个信息

    public Msg add(String key,Object value){
        this.getExtend().put(key,value);
        return this;
    }
    public int getCode() {
        return code;
    }

    public void setCode(int code) {
        this.code = code;
    }

    public String getMsg() {
        return msg;
    }

    public void setMsg(String msg) {
        this.msg = msg;
    }

    public Map<String, Object> getExtend() {
        return extend;
    }

    public void setExtend(Map<String, Object> extend) {
        this.extend = extend;
    }
}
