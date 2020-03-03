package com.mozart.web.controller;

import java.util.SimpleTimeZone;
import java.util.TimeZone;

import javax.servlet.ServletContextEvent;
import javax.servlet.ServletContextListener;
import javax.servlet.http.HttpSession;
import javax.servlet.http.HttpSessionEvent;
import javax.servlet.http.HttpSessionListener;

import org.apache.log4j.Logger;

import com.mozart.web.controller.agent.AlfaFindCheckinAsync;
import com.mozart.web.controller.agent.AlfaManagerAsync;
import com.mozart.web.controller.agent.AlfaVerificaCertificadoAsync;
import com.mozart.web.controller.agent.TravelInnFolhaAsync;
import com.mozart.web.util.MozartWebUtil;

public class SessionListener implements HttpSessionListener,
		ServletContextListener {
	private Logger log = Logger.getLogger(getClass());
	private HttpSession session = null;
	private static int qtdeSession = 0;
	public static Thread alfaAsync = null;
	public static Thread alfaFindCheckinAsync = null;
	public static Thread alfaVerificaCertificado = null;
	public static Thread tinnFolha = null;

	public void sessionCreated(HttpSessionEvent event) {
		this.session = event.getSession();
		MozartWebUtil.warn(null, "Sessao criada: " + this.session.getId(),
				this.log);
		qtdeSession += 1;
		MozartWebUtil.warn(null, "Qtde Sessao: " + qtdeSession, this.log);
	}

	public void sessionDestroyed(HttpSessionEvent event) {
		this.session = event.getSession();
		MozartWebUtil.warn(null, "Fechando sessao: " + this.session.getId(),
				this.log);

		qtdeSession -= 1;
		MozartWebUtil.warn(null, "Qtde Sessao: " + qtdeSession, this.log);
	}

	public void contextInitialized(ServletContextEvent servletContextEvent) {
		MozartWebUtil.warn(null, "Contexto inicializado. ", this.log);
		String parContexto = servletContextEvent.getServletContext()
				.getInitParameter("ATIVAR_SERVICOS");

		TimeZone.setDefault(new SimpleTimeZone(TimeZone.getDefault()
				.getRawOffset(), "America/Sao_Paulo", 9, 16, 0, 3600000, 1, 15,
				0, 7200000, 3600000));
		if ("TRUE".equalsIgnoreCase(parContexto)) {
			try {
				alfaAsync = new Thread(new AlfaManagerAsync());
				alfaAsync.start();
			} catch (Exception ex) {
				MozartWebUtil.warn(null,
						"Erro ao iniciar thread AlfaManagerAsync: "
								+ ex.getMessage(), this.log);
			}
			try {
				alfaFindCheckinAsync = new Thread(new AlfaFindCheckinAsync());
				alfaFindCheckinAsync.start();
			} catch (Exception ex) {
				MozartWebUtil.warn(null,
						"Erro ao iniciar thread AlfaFindCheckinAsync: "
								+ ex.getMessage(), this.log);
			}
			try {
				alfaVerificaCertificado = new Thread(
						new AlfaVerificaCertificadoAsync());
				alfaVerificaCertificado.start();
			} catch (Exception ex) {
				MozartWebUtil.warn(null,
						"Erro ao iniciar thread AlfaVerificaCertificadoAsync: "
								+ ex.getMessage(), this.log);
			}
			try {
				tinnFolha = new Thread(new TravelInnFolhaAsync());
				tinnFolha.start();
			} catch (Exception ex) {
				MozartWebUtil.warn(null,
						"Erro ao iniciar thread TravelInnFolhaAsync: "
								+ ex.getMessage(), this.log);
			}
		}
	}

	public void contextDestroyed(ServletContextEvent servletContextEvent) {
		MozartWebUtil.warn(null, "Contexto interrompido.", this.log);
			
		String parContexto = servletContextEvent.getServletContext()
				.getInitParameter("ATIVAR_SERVICOS");
		if ("TRUE".equalsIgnoreCase(parContexto)) {
			try {
				alfaAsync.interrupt();
				alfaAsync = null;
			} catch (Exception ex) {
				MozartWebUtil.warn(null, "Erro ao finalizar thread alfaAsync: "
						+ ex.getMessage(), this.log);
			}
			try {
				alfaFindCheckinAsync.interrupt();
				alfaFindCheckinAsync = null;
			} catch (Exception ex) {
				MozartWebUtil.warn(null,
						"Erro ao finalizar thread alfaFindCheckinAsync: "
								+ ex.getMessage(), this.log);
			}
			try {
				alfaVerificaCertificado.interrupt();
				alfaVerificaCertificado = null;
			} catch (Exception ex) {
				MozartWebUtil.warn(null,
						"Erro ao finalizar thread AlfaVerificaCertificadoAsync: "
								+ ex.getMessage(), this.log);
			}
			try {
				tinnFolha.interrupt();
				tinnFolha = null;
			} catch (Exception ex) {
				MozartWebUtil.warn(null,
						"Erro ao finalizar thread TravelInnFolhaAsync: "
								+ ex.getMessage(), this.log);
			}
		}
	}
}