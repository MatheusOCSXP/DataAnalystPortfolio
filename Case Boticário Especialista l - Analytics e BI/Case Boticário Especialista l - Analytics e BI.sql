SELECT
  franquia AS id_franquia,
  nome_loja,
  layout AS layout_loja,
  CONCAT(estado, ', Brasil') AS regiao_geo,
  canal,
  marca,
  localidade AS local_operacao,
  area_vendas AS area_vendas_m2,
  area_total AS area_total_m2,
  intervencao AS tipo_intervencao_obra,  
  ano,
  construtora,
  valor_pago_obra,
  valor_pago_aditivo,
  valor_pago_homologado,
  valores_pagos_tapumes_adesivos,
  valores_pagos_frete,
  valores_pagos_projetos,
  valor_pago_obra + valor_pago_aditivo AS valor_total_obra_civil,
  valor_pago_obra + valor_pago_aditivo + valor_pago_homologado +
  valores_pagos_tapumes_adesivos + valores_pagos_frete + valores_pagos_projetos AS capex,
  CASE
    WHEN canal = 'LOJA' THEN (valor_pago_obra + valor_pago_aditivo + valor_pago_homologado +
  valores_pagos_tapumes_adesivos + valores_pagos_frete + valores_pagos_projetos) / area_vendas
    WHEN canal = 'VD' THEN (valor_pago_obra + valor_pago_aditivo + valor_pago_homologado +
  valores_pagos_tapumes_adesivos + valores_pagos_frete + valores_pagos_projetos) / area_total
  END
    AS valor_m2
FROM
  `disco-city-378003.case_boticario.m2_pdv`
WHERE
  layout != 'PRISMA 2.0'
  AND layout != 'LAS VEGAS'
  AND valor_pago_obra > 0
ORDER BY
  1