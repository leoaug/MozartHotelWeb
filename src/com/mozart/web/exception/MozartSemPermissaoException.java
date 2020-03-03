package com.mozart.web.exception;

import javax.servlet.ServletException;

public class MozartSemPermissaoException extends ServletException{
	
	private static final long serialVersionUID = -1980674349501752757L;

	public MozartSemPermissaoException() {
    }

    public MozartSemPermissaoException(String erro) {
        super(erro);
    }

    public MozartSemPermissaoException(Throwable erro) {
        super(erro);
    }
    

}
