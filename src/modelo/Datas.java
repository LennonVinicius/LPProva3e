package modelo;

import java.sql.Date;
import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.time.format.DateTimeParseException;
import java.time.format.ResolverStyle;

public class Datas {

    public static final DateTimeFormatter FORMATO = DateTimeFormatter.ofPattern("dd/MM/uuuu").withResolverStyle(ResolverStyle.STRICT);

    private Datas() {
    }

    public static LocalDate deSql(Date data) {
        if (data == null) {
            return null;
        }
        return data.toLocalDate();
    }

    public static Date paraSql(LocalDate data) {
        if (data == null) {
            return null;
        }
        return Date.valueOf(data);
    }

    public static String formatar(LocalDate data) {
        if (data == null) {
            return "";
        }
        return data.format(FORMATO);
    }

    public static LocalDate converter(String texto) {
        if (texto == null || texto.isBlank()) {
            return null;
        }
        try {
            LocalDate data = LocalDate.parse(texto.trim(), FORMATO);
            if (data.isAfter(LocalDate.now())) {
                throw new IllegalArgumentException("A data de nascimento não pode ser futura.");
            }
            return data;
        } catch (DateTimeParseException e) {
            throw new IllegalArgumentException("Data inválida. Use o formato dd/MM/aaaa.");
        }
    }
}
