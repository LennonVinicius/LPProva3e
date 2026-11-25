package modelo;

public class CpfValidador {

    private CpfValidador() {
    }

    public static String somenteDigitos(String cpf) {
        String numeros = "";
        if (cpf == null) {
            return numeros;
        }
        for (int i = 0; i < cpf.length(); i++) {
            char c = cpf.charAt(i);
            if (c >= '0' && c <= '9') {
                numeros += c;
            }
        }
        return numeros;
    }

    public static String formatar(String cpf) {
        if (cpf == null) {
            return "";
        }
        String d = somenteDigitos(cpf);
        if (d.length() != 11) {
            return cpf;
        }
        return d.substring(0, 3) + "." + d.substring(3, 6) + "." + d.substring(6, 9) + "-" + d.substring(9);
    }

    public static boolean validar(String cpf) {
        if (cpf == null) {
            return false;
        }

        String d = cpf.replace(".", "").replace("-", "").replace(" ", "");
        if (d.length() != 11) {
            return false;
        }

        boolean todosIguais = true;
        for (int i = 0; i < d.length(); i++) {
            char c = d.charAt(i);
            if (c < '0' || c > '9') {
                return false;
            }
            if (c != d.charAt(0)) {
                todosIguais = false;
            }
        }
        if (todosIguais) {
            return false;
        }

        int primeiro = digito(d, 9);
        int segundo = digito(d, 10);
        return primeiro == d.charAt(9) - '0' && segundo == d.charAt(10) - '0';
    }

    private static int digito(String d, int tamanho) {
        int soma = 0;
        for (int i = 0; i < tamanho; i++) {
            soma += (d.charAt(i) - '0') * (tamanho + 1 - i);
        }
        int resto = (soma * 10) % 11;
        if (resto == 10) {
            return 0;
        }
        return resto;
    }
}
