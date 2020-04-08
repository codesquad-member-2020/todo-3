package todo3.codesquad;

import org.springframework.data.jdbc.repository.query.Query;
import org.springframework.data.repository.CrudRepository;
import org.springframework.data.repository.query.Param;

import java.util.Optional;

public interface CardRepository extends CrudRepository<Card,Long> {
//    @Query("SELECT * FROM card WHERE id = :colName")
//    Optional<Card> findById(@Param("colName") String colName);
}
