package com.mozart.web.controller.agent;

import com.mozart.model.delegate.AlfaDelegate;
import com.mozart.model.delegate.EmailDelegate;
import com.mozart.web.util.MozartWebUtil;
import org.apache.log4j.Logger;

public class AlfaFindCheckinAsync implements Runnable {
	private Logger log = Logger.getLogger(getClass());

	public void run() {
		MozartWebUtil.warn(null, "Iniciando [ALFA AlfaFindCheckinAsync]",
				this.log);
		int erro = 0;
		while (Boolean.TRUE.booleanValue()) {
			try {
				AlfaDelegate.gerarCertificados();
				Thread.sleep(30000L);
				erro = 0;
			} catch (Exception ex) {
				ex.printStackTrace();
				String msgErro = "Erro na geracao dos certificados: "
						+ ex.getMessage();
				EmailDelegate
						.instance()
						.send(
								null,
								com.mozart.web.util.MozartConstantesWeb.EMAIL_ADM_MOZART[0],
								com.mozart.web.util.MozartConstantesWeb.EMAIL_ADM_MOZART[1],
								"#ERRO - AlfaFindCheckinAsync#", msgErro);
				MozartWebUtil.error(null, msgErro, this.log);
				erro++;
				if (erro > 5) {
					EmailDelegate
							.instance()
							.send(
									null,
									com.mozart.web.util.MozartConstantesWeb.EMAIL_ADM_MOZART[0],
									com.mozart.web.util.MozartConstantesWeb.EMAIL_ADM_MOZART[1],
									"#URGENTE - AlfaFindCheckinAsync - FINALIZADO#",
									msgErro);

					throw new RuntimeException(ex.getMessage());
				}
			}
		}
	}
}