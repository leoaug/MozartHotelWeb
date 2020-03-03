package com.mozart.web.util;

public class MozartComboWeb {
    
    private String id;
    private String value;

    public MozartComboWeb(String id, String value) {
        this.id = id;
        this.value= value;
    }


    public void setId(String key) {
        this.id = key;
    }

    public String getId() {
        return id;
    }

    public void setValue(String value) {
        this.value = value;
    }

    public String getValue() {
        return value;
    }
}
