package com.mozart.web.helper;

import com.mozart.model.ejb.entity.MenuMozartWebEJB;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.Collections;
import java.util.List;

public class ArvorePermissaoHelper {

	List<MenuMozartWebEJB> menus;
	List<Long> idProgramas;

	public ArvorePermissaoHelper(List<MenuMozartWebEJB> menus,
			Long... idProgramas) {
		this.menus = menus;
		this.idProgramas = Arrays.asList(idProgramas);
	}

	public String build() {

		StringBuilder build = new StringBuilder();

		List<MenuMozartWebEJB> icones = new ArrayList<MenuMozartWebEJB>();
		for (MenuMozartWebEJB menu : menus) {
				if ("I".equalsIgnoreCase(menu.getTipoMenu())) {
					icones.add(menu);
					continue;
				}
				String result = menuToString(menu);
				build.append(result);
		}

		for (MenuMozartWebEJB icon : icones) {
			String result = menuToString(icon);
			build.append(result);
		}

		return build.toString();
	}

	private String menuToString(MenuMozartWebEJB menu) {

		StringBuilder result = new StringBuilder();
		result.append(" <li>\n"
				+ "     <input type='checkbox' name='ids' id='p_"
				+ menu.getIdMenuItem() + "' value='" + menu.getIdMenuItem()
				+ "'>\n" + "     <label><img src=\"" + menu.getDsImagem()
				+ "\"/>\n" + menu.getDsMenu() + "\n</label>");
		if (menu.getMenuMozartWebEJBList() != null
				&& menu.getMenuMozartWebEJBList().size() > 0) {
			result.append("<ul> ");

			for (MenuMozartWebEJB filho : menu.getMenuMozartWebEJBList()) {
				if(idProgramas.contains(filho.getIdPrograma()))
					result.append(menuToString(filho));
			}

			result.append("</ul> ");
		} else {
			result.append("</li> ");
		}

		return result.toString();
	}
}
