package com.mozart.web.converter;

import com.mozart.model.util.MozartUtil;
import java.sql.Timestamp;
import java.util.Calendar;
import java.util.Date;
import java.util.Map;
import org.apache.struts2.util.StrutsTypeConverter;

@SuppressWarnings("unchecked")
public class DateConverter extends StrutsTypeConverter {
	private static Calendar cal = Calendar.getInstance();

	public Object convertFromString(Map map, String[] strings, Class class1) {
		if (class1 == Timestamp.class) {
			return MozartUtil
					.toTimestamp(strings[0].startsWith("16/10") ? strings[0]
							+ " 01:00:00" : strings[0]);
		}
		if (class1 == Date.class) {
			return MozartUtil.toDate(strings[0]);
		}
		return null;
	}

	public String convertToString(Map map, Object object) {
		if ((object instanceof Timestamp)) {
			cal.setTime((Timestamp) object);
			String result = "";
			if (cal.get(13) > 0) {
				result = MozartUtil.format((Timestamp) object,
						"dd/MM/yyyy HH:mm:ss");
			} else {
				result = MozartUtil.format((Timestamp) object, "dd/MM/yyyy");
			}
			return result;
		}
		if ((object instanceof Date)) {
			return MozartUtil.format((Date) object, "dd/MM/yyyy");
		}
		return null;
	}
}