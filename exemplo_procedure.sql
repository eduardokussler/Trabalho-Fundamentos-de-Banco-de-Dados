DROP FUNCTION my_function;

CREATE OR REPLACE FUNCTION my_function(app_id integer) RETURNS TABLE(id integer, nome VARCHAR(50), tags_pop VARCHAR(50)) AS $$
    BEGIN
         RETURN QUERY
SELECT App.id, Produto.nome, C.tag FROM App
  INNER JOIN Produto ON App.id = Produto.id 
  INNER JOIN LATERAL (
    SELECT tags.fk_app_id as id, Tags.tag as tag, count(tag) FROM Tags
    GROUP BY tags.fk_app_id, tags.tag
    HAVING tags.fk_app_id = app.id
    ORDER BY count(tag)
    LIMIT 4
  ) AS C ON App.id = C.id
  WHERE App.id = app_id;
    END;
$$ LANGUAGE plpgsql;

