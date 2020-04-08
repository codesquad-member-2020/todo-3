package todo3.codesquad;

import org.springframework.data.jdbc.repository.query.Query;
import org.springframework.data.repository.CrudRepository;
import org.springframework.data.repository.query.Param;

public interface ColRepository extends CrudRepository<Col, Long> {

    @Query("SELECT * FROM col WHERE col_name = :colName")
    Col findByColName(@Param("colName") String colName);
}
