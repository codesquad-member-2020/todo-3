package todo3.codesquad.domain;

import org.springframework.data.jdbc.repository.query.Query;
import org.springframework.data.repository.CrudRepository;
import org.springframework.data.repository.query.Param;

import java.util.List;
import java.util.Optional;

public interface ColRepository extends CrudRepository<Col, Long> {

    @Query("SELECT * FROM col WHERE col_name = :colName")
    Optional<Col> findByColName(@Param("colName") String colName);

    @Query("select id from col where col.deleted = false")
    List<Integer> findColIdByNotDeleted();

    @Query("select col_name from col where col.id = :id")
    String findColNameByNotDeleted(@Param("id") Integer id);
}
