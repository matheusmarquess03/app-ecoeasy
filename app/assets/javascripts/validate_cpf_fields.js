$(document).on('submit', function(event){

    $('.cpf-field').map(function() {

        var cpf = $(this).val();
        var response = validateCPF(cpf);

        if (response == false) {

            alert('CPF Inválido');

            event.preventDefault();

            return response;

        }

    });

});
