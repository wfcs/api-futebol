let
    // Substitua o ID do campeonato diretamente na URL
    campeonato_id = "10",
    endpoint = "campeonatos/" & campeonato_id & "/partidas",
    url = "https://api.api-futebol.com.br/v1/" & endpoint,
    // Cabeçalho de autenticação
    authHeader = "Bearer " & ApiKey,
    // Solicitação Web
    Source = Web.Contents(url, [Headers=[Authorization=authHeader]]),
    response = Json.Document(Source, 65001),
    ConvertedTable = Record.ToTable(response),
    ExpandedValue = Table.ExpandRecordColumn(ConvertedTable, "Value", {"campeonato_id", "nome", "slug", "fase-unica"}, {"campeonato_id", "nome", "slug", "fase-unica"}),
    ExpandedPartidas = Table.ExpandRecordColumn(ExpandedValue, "fase-unica", {"1a-rodada", "2a-rodada", "3a-rodada", "4a-rodada", "5a-rodada", "6a-rodada", "7a-rodada", "8a-rodada", "9a-rodada", "10a-rodada", "11a-rodada", "12a-rodada", "13a-rodada", "14a-rodada", "15a-rodada", "16a-rodada", "17a-rodada", "18a-rodada", "19a-rodada", "20a-rodada", "21a-rodada", "22a-rodada", "23a-rodada", "24a-rodada", "25a-rodada", "26a-rodada", "27a-rodada", "28a-rodada", "29a-rodada", "30a-rodada", "31a-rodada", "32a-rodada", "33a-rodada", "34a-rodada", "35a-rodada", "36a-rodada", "37a-rodada", "38a-rodada"}, {"1a-rodada", "2a-rodada", "3a-rodada", "4a-rodada", "5a-rodada", "6a-rodada", "7a-rodada", "8a-rodada", "9a-rodada", "10a-rodada", "11a-rodada", "12a-rodada", "13a-rodada", "14a-rodada", "15a-rodada", "16a-rodada", "17a-rodada", "18a-rodada", "19a-rodada", "20a-rodada", "21a-rodada", "22a-rodada", "23a-rodada", "24a-rodada", "25a-rodada", "26a-rodada", "27a-rodada", "28a-rodada", "29a-rodada", "30a-rodada", "31a-rodada", "32a-rodada", "33a-rodada", "34a-rodada", "35a-rodada", "36a-rodada", "37a-rodada", "38a-rodada"}),
    Unpivoted = Table.UnpivotOtherColumns(ExpandedPartidas, {"Name", "campeonato_id", "nome", "slug"}, "Rodada", "Value"),
    ExpandedValue1 = Table.ExpandListColumn(Unpivoted, "Value"),
    ExpandedValue2 = Table.ExpandRecordColumn(ExpandedValue1, "Value", {"partida_id", "time_mandante", "time_visitante", "status", "slug", "data_realizacao", "hora_realizacao", "data_realizacao_iso", "_link"}, {"partida_id", "time_mandante", "time_visitante", "status", "slug.1", "data_realizacao", "hora_realizacao", "data_realizacao_iso", "_link"}),
    RemovedColumns = Table.RemoveColumns(ExpandedValue2,{"campeonato_id", "nome", "slug", "Name", "_link", "slug.1", "data_realizacao_iso"}),
    time_mandante = Table.ExpandRecordColumn(RemovedColumns, "time_mandante", {"time_id"}, {"time_mandante_id"}),
    time_visitante = Table.ExpandRecordColumn(time_mandante, "time_visitante", {"time_id"}, {"time_visitante_id"}),
    ChangedType = Table.TransformColumnTypes(time_visitante,{{"hora_realizacao", type time}, {"data_realizacao", type date}, {"status", type text}, {"partida_id", Int64.Type}, {"time_mandante_id", Int64.Type}, {"time_visitante_id", Int64.Type}})
in
    ChangedType
