package todo3.codesquad;

import org.springframework.data.jdbc.repository.query.Query;
import org.springframework.data.repository.CrudRepository;
import org.springframework.data.repository.query.Param;

import java.util.Optional;

public interface ColRepository extends CrudRepository<Col, Long> {

    @Query("SELECT * FROM col WHERE col_name = :colName")
    Optional<Col> findByColName(@Param("colName") String colName);
}
