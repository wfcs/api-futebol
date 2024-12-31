(Id_Time as number )=> 

let
    // Substitua o ID do campeonato diretamente na URL
    // https://api.api-futebol.com.br/v1/times/{time_id}
    time_id = Text.From(Id_Time),
    endpoint = "v1/times/" & time_id ,
    url = url & endpoint,
    // Cabeçalho de autenticação
    authHeader = "Bearer " & ApiKey,
    // Solicitação Web
    Source = Web.Contents(url, [Headers=[Authorization=authHeader]]),
    response = Json.Document(Source, 65001),
    ConvertedTable = Table.PromoteHeaders( Table.Transpose( Record.ToTable(response) ) )
in
    ConvertedTable
