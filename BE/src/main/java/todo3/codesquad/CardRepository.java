package todo3.codesquad;

import org.springframework.data.jdbc.repository.query.Query;
import org.springframework.data.repository.CrudRepository;
import org.springframework.data.repository.query.Param;

import java.util.List;


public interface CardRepository extends CrudRepository<Card,Long> {
    @Query("select * from card where card.deleted = false and card.col = :id order by card.row asc")
    List<Card> findAllByColumnCard(@Param("id") Integer id);
}
