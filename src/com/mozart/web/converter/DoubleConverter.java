package com.mozart.web.converter;

import com.mozart.model.util.MozartUtil;
import java.util.Map;
import org.apache.struts2.util.StrutsTypeConverter;
@SuppressWarnings("unchecked")
public class DoubleConverter extends StrutsTypeConverter {
    
    
	public Object convertFromString(Map map, String[] strings, Class class1) {
        
        if (class1 == Double.class){
            return MozartUtil.toDouble( strings[0] );
        }
        return null;
    }

    
	public String convertToString(Map map, Object object) {
        return MozartUtil.format( (Double) object );
    }
}
