package com.mozart.web.exception;

import javax.servlet.ServletException;

public class MozartUsuarioException extends ServletException{

    /**
	 * 
	 */
	private static final long serialVersionUID = -1980674349501752757L;

	public MozartUsuarioException() {
    }

    public MozartUsuarioException(String erro) {
        super(erro);
    }

    public MozartUsuarioException(Throwable erro) {
        super(erro);
    }
}
